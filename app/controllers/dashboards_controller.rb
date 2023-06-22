# frozen_string_literal: true

class DashboardsController < ApplicationController

  before_action :authenticate_if_logins_enabled

  def index
    if WasteCarriersEngine::FeatureToggle.active?(:block_front_end_logins)
      redirect_to root_path 
      return
    end

    @registrations = WasteCarriersEngine::Registration.where(account_email: current_user.email,
                                                              :"metaData.status".ne => "INACTIVE")
                                                      .order_by("metaData.dateRegistered": :asc)
                                                      .page(params[:page])
  end
end
