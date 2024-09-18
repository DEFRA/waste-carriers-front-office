# frozen_string_literal: true

Rails.application.routes.draw do

  root to: "waste_carriers_engine/start_forms#new"

  devise_for :users,
             controllers: { sessions: "sessions" },
             skip: :all

  mount WasteCarriersEngine::Engine => "/fo"

  mount DefraRubyMocks::Engine => "/fo/mocks"
end
