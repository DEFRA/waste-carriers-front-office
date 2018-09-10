# frozen_string_literal: true

# This file adds seeds by parsing the JSON files in the db/seeds/ folder.

# If a "date_flag" is set for a seed, we generate the dates dynamically.
# This ensures a seed which is always intended to be in a time-sensitive state
# remains in that state without having to manually update the dates.

def registered_date(flag)
  # Resetting variables here so it's easier to read calculations below
  expires_after = Rails.configuration.expires_after
  renewal_window = Rails.configuration.renewal_window

  dates = {
    # Registration should have expired 1 month ago
    expired: expires_after.years.ago - 1.month,
    # Registration should be halfway through the renewal window
    in_renewal_window: expires_after.years.ago + (renewal_window / 2).months,
    # Registration is not yet in the renewal window
    outside_renewal_window: expires_after.years.ago + (renewal_window * 2).months
  }

  dates[flag.to_sym] || Date.today
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

def seed_users
  seeds = JSON.parse(File.read("#{Rails.root}/db/seeds/users.json"))
  users = seeds["users"]

  users.each do |user|
    User.find_or_create_by(
      email: user["email"],
      password: ENV["WCRS_DEFAULT_PASSWORD"] || "Secret123",
      confirmed_at: Time.new(2015, 1, 1)
    )
  end
end

def seed_registrations
  seeds = []
  Dir.glob("#{Rails.root}/db/seeds/CBD*.json").each do |file|
    seeds << JSON.parse(File.read(file))
  end

  seeds.each do |seed|
    next unless seed["date_flag"].present?

    parse_dates(seed, registered_date(seed["date_flag"]))
    seed.delete("date_flag")
  end

  # Sort seeds to list ones with regIdentifiers first
  sorted_seeds = seeds.select { |s| s.key?("regIdentifier") } + seeds.reject { |s| s.key?("regIdentifier") }

  sorted_seeds.each do |seed|
    WasteCarriersEngine::Registration.find_or_create_by(seed.except("_id"))
  end
end

# Only seed if not running in production or we specifically require it, eg. for Heroku
if !Rails.env.production? || ENV["WCR_ALLOW_SEED"]
  seed_users
  seed_registrations
end
