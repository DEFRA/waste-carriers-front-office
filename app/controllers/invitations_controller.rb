# frozen_string_literal: true

class InvitationsController < Devise::InvitationsController
  helper WasteCarriersEngine::ApplicationHelper

  def edit
    if WasteCarriersEngine::FeatureToggle.active?(:block_front_end_logins)
      redirect_to root_path 
      return
    end

    super
  end

  def update
    if WasteCarriersEngine::FeatureToggle.active?(:block_front_end_logins)
      redirect_to root_path 
      return
    end

    super
  end

  def after_accept_path_for(_resource)
    fo_path
  end
end
