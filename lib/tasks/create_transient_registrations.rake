# frozen_string_literal: true

desc "Attempt to create transient_registrations in the database from all active, upper-tier registrations"
task create_transient_registrations: :environment do
  log_path = "log/create_transient_registrations_#{Time.current.to_i}.log"
  log = ActiveSupport::Logger.new(log_path)

  counts = {
    total: 0,
    success: 0,
    error: 0
  }
  counts[:total] = renewable_registrations.count

  paging = {
    page_size: 1000,
    page_number: 1,
    num_of_pages: (counts[:total] / 1000).ceil
  }

  print "Finding all active upper-tier registrations..."
  puts " #{counts[:total]} matching registrations found.\n\n"

  counts = page_through_registrations(paging, counts, log)

  puts "\nAttempted creation of #{counts[:total]} transient_registrations complete"
  puts "Errors: #{counts[:error]}"
  puts "Successes: #{counts[:success]}"
  puts "Details saved to #{log_path}"
end

def registrations_collection
  Mongoid::Clients.default.database.collections.find { |c| c.name == "registrations" }
end

def renewable_registrations
  registrations_collection.find(tier: "UPPER", "metaData.status": "ACTIVE").no_cursor_timeout
end

def paged_renewable_registrations(paging)
  registrations_collection
    .find(tier: "UPPER", "metaData.status": "ACTIVE")
    .skip(paging[:page_size] * (paging[:page_number] - 1))
    .limit(paging[:page_size])
end

def page_through_registrations(paging, counts, log)
  while paging[:page_number] <= paging[:num_of_pages]
    counts = test_registrations(paged_renewable_registrations(paging), counts, log)
    paging[:page_number] += 1
  end
  counts
end

def test_registrations(registrations, counts, log)
  registrations.each do |registration|
    reg_identifier = registration["regIdentifier"]
    print "  creating transient_registration for #{reg_identifier}..."

    begin
      transient_registration = WasteCarriersEngine::TransientRegistration.new(reg_identifier: reg_identifier)
      transient_registration.save!
      counts[:success] += 1
      puts " ✓"
    rescue StandardError => e
      puts " ERROR"
      counts[:error] += 1

      log.info "\n----------"
      log.info "#{reg_identifier} - attempt to create transient_registration failed"
      log.info e.to_s
    end
  end

  counts
end
