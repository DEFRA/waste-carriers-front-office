# frozen_string_literal: true

class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    redirect_to(Rails.configuration.wcrs_frontend_url)
  end
end
