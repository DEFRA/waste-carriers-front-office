# frozen_string_literal: true

# This task is for creating large volumes of registrations to support profiling
# of resource-intensive back-office processes. It is based on seeds.rb, adding seeds
# by parsing the JSON files in the db/seeds/ folder, but creating multiple registration
# instances from each of the JSON seed files, varying only the necessary attributes.

# Usage, where 'registration_multipler' and 'transient_reg_multiplier' are the
# number of registrations and transient_registrations respectively to create per seed file:
#   rake seeds:bulk_registrations[reg_multiplier, transient_reg_multiplier]

# If a "date_flag" is set for a seed, we generate the dates dynamically.
# This ensures a seed which is always intended to be in a time-sensitive state
# remains in that state without having to manually update the dates.

namespace :seeds do
  desc "Create bulk registrations and transient registrations for profiling purposes"
  task :bulk_registrations, %i[reg_multiplier transient_reg_multiplier] => :environment do |_task, args|
    raise StandardError, "Attempted to run bulk seed task in production" if Rails.env.production?

    if args[:transient_reg_multiplier].blank?
      puts "Usage: rake seeds:bulk_registrations[reg_multiplier, transient_reg_multiplier]"
      exit
    end

    reg_multiplier = args[:reg_multiplier].to_i
    transient_reg_multiplier = args[:transient_reg_multiplier].to_i
    if transient_reg_multiplier > reg_multiplier
      puts "transient_reg_multiplier must be no greater than reg_multiplier"
      exit
    end

    bulk_seed_registrations(raw_seeds(reg_multiplier))
    bulk_seed_transient_registrations(raw_seeds(transient_reg_multiplier))

    puts "Bulk seeding complete. " \
         "Registrations: #{WasteCarriersEngine::Registration.count}; " \
         "TransientRegistrations: #{WasteCarriersEngine::TransientRegistration.count}"
  end
end

def bulk_seed_registrations(base_seeds)
  puts "creating registrations..."
  base_seeds.each do |seed|
    Timecop.freeze(seed["metaData"]["lastModified"])
    WasteCarriersEngine::Registration.create!(seed.except("_id"))
  rescue StandardError => e
    puts "Skipping registration #{seed['regIdentifier']}: #{e}"
  ensure
    Timecop.return
  end
end

def bulk_seed_transient_registrations(base_seeds)
  puts "creating transient_registrations..."
  base_seeds.each do |seed|
    Timecop.freeze(seed["metaData"]["lastModified"])
    reg = WasteCarriersEngine::Registration.find_by(regIdentifier: seed["regIdentifier"])
    WasteCarriersEngine::RenewingRegistration.create!(
      seed.except("_id")
        .merge(regIdentifier: reg.regIdentifier,
               conviction_sign_offs: [WasteCarriersEngine::ConvictionSignOff.new(confirmed: %w[yes no].sample)],
               workflow_state: %w[renewal_complete_form
                                  renewal_received_pending_conviction_form
                                  renewal_received_pending_payment_form
                                  renewal_received_pending_worldpay_payment_form].sample)
    )
  rescue StandardError => e
    puts "Skipping transient_registration #{seed['regIdentifier']}: #{e}"
  ensure
    Timecop.return
  end
end

def raw_seeds(multiplier)
  seeds = []
  Rails.root.join("db/seeds").glob("CBD*.json") do |file|
    base_seed = JSON.parse(File.read(file))
    puts "creating raw seeds for base reg id #{base_seed['regIdentifier']}..."
    (0..multiplier).each do |i|
      seed = base_seed.dup
      seed["regIdentifier"] = "#{base_seed['regIdentifier']}#{i}"
      seeds << seed
    end
  end

  seeds.each do |seed|
    next if seed["date_flag"].blank?

    parse_dates(seed, registered_date(seed["date_flag"]))
    seed.delete("date_flag")
  end

  # Sort seeds to list ones with regIdentifiers first
  seeds.select { |s| s.key?("regIdentifier") } + seeds.reject { |s| s.key?("regIdentifier") }
end

def parse_dates(seed, date)
  seed["metaData"]["dateRegistered"] = date
  seed["metaData"]["lastModified"] = date
  seed["metaData"]["dateActivated"] = date
  seed["conviction_search_result"]["searched_at"] = date
  seed["expires_on"] = date + 3.years
  seed["key_people"].each do |key_person|
    key_person["conviction_search_result"]["searched_at"] = date
  end
end

def registered_date(flag) # rubocop:disable Metrics/AbcSize
  @expires_after ||= Rails.configuration.expires_after
  @renewal_window ||= Rails.configuration.renewal_window
  @grace_window ||= Rails.configuration.grace_window

  @dates ||= {
    expired: @expires_after.years.ago - 1.month,
    within_grace_period_window: @expires_after.years.ago - (@grace_window - 1).day,
    in_renewal_window: @expires_after.years.ago + (@renewal_window / 2).months,
    outside_renewal_window: @expires_after.years.ago + (@renewal_window * 2).months,
    seven_years_old: 7.years.ago,
    eight_years_old: 8.years.ago
  }

  @dates[flag.to_sym] || Time.zone.today
end
