# frozen_string_literal: true

module DashboardsHelper
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
