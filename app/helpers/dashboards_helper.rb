# frozen_string_literal: true

module DashboardsHelper
  def url_to_change_password
    edit_passwords_path
  end

  def url_for_new_registration
    if WasteCarriersEngine::FeatureToggle.active?(:new_registration)
      WasteCarriersEngine::Engine.routes.url_helpers.new_start_form_path
    else
      File.join(Rails.configuration.wcrs_frontend_url, "registrations/start")
    end
  end

  def display_view_certificate_link_for?(registration)
    registration.metaData.ACTIVE?
  end

  def display_renew_link_for?(registration)
    return false unless registration.tier == "UPPER"

    reg_id = registration.reg_identifier
    # Use existing transient_registration or create a temporary new one
    transient_registration = WasteCarriersEngine::RenewingRegistration.where(reg_identifier: reg_id).first ||
                             WasteCarriersEngine::RenewingRegistration.new(reg_identifier: reg_id)

    transient_registration.can_be_renewed?
  end

  def display_no_action_links?(registration)
    return false if display_view_certificate_link_for?(registration) ||
                    display_renew_link_for?(registration)

    true
  end

  def view_certificate_url(registration)
    certificate_path(registration.reg_identifier)
  end

  def renew_url(registration)
    WasteCarriersEngine::Engine.routes.url_helpers.new_renewal_start_form_path(registration.reg_identifier)
  end

  private

  def base_frontend_registration_url(registration)
    id = registration["_id"]
    "#{Rails.configuration.wcrs_frontend_url}/registrations/#{id}"
  end
end
