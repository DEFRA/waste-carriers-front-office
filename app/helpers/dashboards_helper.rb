# frozen_string_literal: true

module DashboardsHelper
  def url_to_change_password
    "#{Rails.configuration.wcrs_frontend_url}/users/edit"
  end

  def url_for_new_registration
    "#{Rails.configuration.wcrs_frontend_url}/registrations/find"
  end

  def display_view_certificate_link_for?(registration)
    registration.metaData.ACTIVE?
  end

  def display_edit_link_for?(registration)
    registration.metaData.ACTIVE? || registration.metaData.PENDING?
  end

  def display_renew_link_for?(registration)
    return false unless registration.tier == "UPPER"

    reg_id = registration.reg_identifier
    # Use existing transient_registration or create a temporary new one
    transient_registration = WasteCarriersEngine::RenewingRegistration.where(reg_identifier: reg_id).first ||
                             WasteCarriersEngine::RenewingRegistration.new(reg_identifier: reg_id)

    transient_registration.can_be_renewed?
  end

  def display_order_cards_link_for?(registration)
    return false unless registration.tier == "UPPER"

    registration.metaData.ACTIVE? || registration.metaData.PENDING?
  end

  def display_delete_link_for?(registration)
    registration.metaData.ACTIVE?
  end

  def display_no_action_links?(registration)
    return false if display_view_certificate_link_for?(registration) ||
                    display_edit_link_for?(registration) ||
                    display_renew_link_for?(registration) ||
                    display_order_cards_link_for?(registration) ||
                    display_delete_link_for?(registration)

    true
  end

  def view_certificate_url(registration)
    "#{base_frontend_registration_url(registration)}/view"
  end

  def edit_url(registration)
    "#{base_frontend_registration_url(registration)}/edit"
  end

  def renew_url(registration)
    WasteCarriersEngine::Engine.routes.url_helpers.new_renewal_start_form_path(registration.reg_identifier)
  end

  def order_cards_url(registration)
    id = registration["_id"]
    "#{Rails.configuration.wcrs_frontend_url}/your-registration/#{id}/order/order-copy_cards"
  end

  def delete_url(registration)
    "#{base_frontend_registration_url(registration)}/confirm_delete"
  end

  private

  def base_frontend_registration_url(registration)
    id = registration["_id"]
    "#{Rails.configuration.wcrs_frontend_url}/registrations/#{id}"
  end
end
