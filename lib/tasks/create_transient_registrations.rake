# frozen_string_literal: true

desc "Attempt to create transient_registrations in the database from all active, upper-tier registrations"
task create_transient_registrations: :environment do
  log_path = "log/create_transient_registrations_#{Time.current.to_i}.log"
  log = ActiveSupport::Logger.new(log_path)

  print "Finding all active upper-tier registrations..."

  registrations = WasteCarriersEngine::Registration.where(tier: "UPPER", "metaData.status": "ACTIVE")

  puts " #{registrations.count} matching registrations found.\n\n"

  error_count = 0

  registrations.each do |registration|
    reg_identifier = registration.reg_identifier
    print "  creating transient_registration for #{reg_identifier}..."

    begin
      transient_registration = WasteCarriersEngine::TransientRegistration.new(reg_identifier: reg_identifier)
      transient_registration.save!
      puts " ✓"
    rescue StandardError => e
      puts " ERROR"
      error_count += 1

      log.info "\n----------"
      log.info "#{reg_identifier} - attempt to create transient_registration failed"
      log.info e.to_s
    end
  end

  puts "\nAttempted creation of #{registrations.count} transient_registrations complete"
  puts "Errors: #{error_count}"
  puts "Details saved to #{log_path}"
end
