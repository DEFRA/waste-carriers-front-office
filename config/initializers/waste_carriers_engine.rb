# frozen_string_literal: true

WasteCarriersEngine.configure do |configuration|
  # Companies house API config
  configuration.companies_house_api_key = ENV.fetch("WCRS_COMPANIES_HOUSE_API_KEY", nil)

  # We only want to alter the companies house URL if mocking is enabled. Else
  # the url is handled by the defra-ruby-validators gem from the wcr engine
  if ENV["WCRS_MOCK_ENABLED"].to_s.downcase == "true"
    configuration.companies_house_host = ENV.fetch("WCRS_MOCK_BO_COMPANIES_HOUSE_URL", nil)
  end

  # Last email cache config
  configuration.use_last_email_cache = ENV["WCRS_USE_LAST_EMAIL_CACHE"] || "false"

  # Configure airbrake, which is done via the engine using defra_ruby_alert
  configuration.airbrake_enabled = ENV.fetch("WCRS_USE_AIRBRAKE", nil)
  configuration.airbrake_host = ENV.fetch("WCRS_AIRBRAKE_URL", nil)
  configuration.airbrake_project_key = ENV.fetch("WCRS_FRONTOFFICE_AIRBRAKE_PROJECT_KEY", nil)
  configuration.airbrake_blocklist = [/password/i, /authorization/i]

  configuration.address_host = ENV["ADDRESSBASE_URL"] || "http://localhost:8005"

  # Notify config
  configuration.notify_api_key = ENV.fetch("NOTIFY_API_KEY", nil)

  # By telling the engine which app it is hosted in it can then make decisions
  # about any changes in behaviour needed. For example, the payment confirmation
  # email from Worldpay is only applicable to users in the front-office. This is
  # because Worldpay does not send one if the merchant code is MOTO. So the
  # engine can use this flag to determine whether to show payment confirmation
  # related content
  configuration.host_is_back_office = false
end
WasteCarriersEngine.start_airbrake
