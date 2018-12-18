# frozen_string_literal: true

module DashboardsHelper
  def url_to_view_certificate_for(registration)
    id = registration["_id"]
    "#{Rails.configuration.wcrs_frontend_url}/registrations/#{id}/view"
  end

  def url_to_edit(registration)
    id = registration["_id"]
    "#{Rails.configuration.wcrs_frontend_url}/registrations/#{id}/edit"
  end

  def url_to_renew(registration)
    WasteCarriersEngine::Engine.routes.url_helpers.new_renewal_start_form_path(registration.reg_identifier)
  end

  def url_to_order_cards_for(_registration)
    "#"
  end

  def url_to_delete(_registration)
    "#"
  end
end
