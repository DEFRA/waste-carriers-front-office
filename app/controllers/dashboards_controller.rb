# frozen_string_literal: true

class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @registrations = WasteCarriersEngine::Registration.where(account_email: current_user.email)
                                                      .order_by("metaData.dateRegistered": :asc)
                                                      .page(params[:page])
  end
end
