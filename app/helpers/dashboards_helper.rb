# frozen_string_literal: true

module DashboardsHelper
  def url_to_view_certificate_for(_registration)
    "#"
  end

  def url_to_edit(_registration)
    "#"
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
