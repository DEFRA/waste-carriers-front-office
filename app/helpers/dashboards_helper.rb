# frozen_string_literal: true

module DashboardsHelper
  def url_to_change_password
    "#{Rails.configuration.wcrs_frontend_url}/users/edit"
  end

  def display_view_certificate_link_for?(registration)
    registration.metaData.ACTIVE?
  end

  def display_edit_link_for?(registration)
    registration.metaData.ACTIVE? || registration.metaData.PENDING?
  end

  def display_renew_link_for?(_registration)
    true
  end

  def display_order_cards_link_for?(registration)
    return false unless registration.tier == "UPPER"

    registration.metaData.ACTIVE? || registration.metaData.PENDING?
  end

  def display_delete_link_for?(registration)
    registration.metaData.ACTIVE?
  end

  def url_to_view_certificate_for(registration)
    "#{base_frontend_registration_url(registration)}/view"
  end

  def url_to_edit(registration)
    "#{base_frontend_registration_url(registration)}/edit"
  end

  def url_to_renew(registration)
    WasteCarriersEngine::Engine.routes.url_helpers.new_renewal_start_form_path(registration.reg_identifier)
  end

  def url_to_order_cards_for(registration)
    id = registration["_id"]
    "#{Rails.configuration.wcrs_frontend_url}/your-registration/#{id}/order/order-copy_cards"
  end

  def url_to_delete(registration)
    "#{base_frontend_registration_url(registration)}/confirm_delete"
  end

  private

  def base_frontend_registration_url(registration)
    id = registration["_id"]
    "#{Rails.configuration.wcrs_frontend_url}/registrations/#{id}"
  end
end
