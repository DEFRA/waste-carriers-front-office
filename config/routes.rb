# frozen_string_literal: true

Rails.application.routes.draw do

  root to: "waste_carriers_engine/start_forms#new"

  devise_for :users,
             controllers: { sessions: "sessions" },
             skip: :all

  mount WasteCarriersEngine::Engine => "/fo", as: "basic_app_engine"

  mount DefraRubyMocks::Engine => "/fo/mocks"

  resource :cookies, only: %i[edit update] do
    member do
      post :accept_analytics
      post :reject_analytics
      post :hide_this_message
    end
  end
end
