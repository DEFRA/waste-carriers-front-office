# frozen_string_literal: true

class SessionsController < Devise::SessionsController

  def new
    if WasteCarriersEngine::FeatureToggle.active?(:block_front_end_logins)
      redirect_to root_path 
      return
    end

    super
  end

  def destroy
    current_user.invalidate_all_sessions!
    super
  end
end
