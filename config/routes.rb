# frozen_string_literal: true

Rails.application.routes.draw do

  root to: "waste_carriers_engine/start_forms#new"

  devise_for :users,
             controllers: { sessions: "sessions" },
             skip: :all

  mount WasteCarriersEngine::Engine => "/fo"

  mount DefraRubyMocks::Engine => "/fo/mocks"

  resource :cookies, only: %i[edit update] do
    member do
      post :accept_analytics
      post :reject_analytics
      post :hide_this_message
    end
  end

  resources :registrations,
    only: :show,
    param: :reg_identifier,
    path: "/bo/registrations" do
      get "certificate", to: "certificates#show"
      get "pdf_certificate", to: "certificates#pdf"
      get "certificate_confirm_email", to: "certificates#confirm_email"
      post "certificate_process_email", to: "certificates#process_email"
    end
end
