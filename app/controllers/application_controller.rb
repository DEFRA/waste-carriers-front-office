# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper WasteCarriersEngine::ApplicationHelper

  # Within our production 'like' environments access to the app can only be
  # obtained through `/fo`. Therefore to make this clear and ensure there is
  # no confusion we redirect all requests to `/` to `/fo`
  # https://stackoverflow.com/a/28822626/6117745
  def redirect_root_to_dashboard
    redirect_to fo_path
  end

  def after_sign_in_path_for(*)
    fo_path
  end

  def after_sign_out_path_for(*)
    new_user_session_path
  end
end
