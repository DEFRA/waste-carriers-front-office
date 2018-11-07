# frozen_string_literal: true

class InvitationsController < Devise::InvitationsController
  helper WasteCarriersEngine::ApplicationHelper

  def after_accept_path_for(_resource)
    fo_path
  end
end
