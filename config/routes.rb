# frozen_string_literal: true

Rails.application.routes.draw do # rubocop:disable Metrics/BlockLength

  root to: "waste_carriers_engine/start_forms#new"

  devise_for :users,
             controllers: { sessions: "sessions" },
             path: "/fo/users",
             path_names: { sign_in: "sign_in", sign_out: "sign_out" },
             skip: [:invitations]

  as :user do
    get   "/fo/users/invitation/accept" => "invitations#edit", as: :accept_user_invitation
    patch "/fo/users/invitation/accept" => "invitations#update", as: :user_invitation
    put   "/fo/users/invitation/accept" => "invitations#update"

    # Used for editing user passwords when they are already logged in
    resource :passwords,
             only: %i[edit update],
             path: "/fo/users/edit-password",
             path_names: { edit: "" }
  end

  get "/fo/registrations/:reg_identifier/certificate", to: "certificates#show", as: :certificate

  get "/fo" => "dashboards#index"

  # Redirect old Devise routes
  get "/users(*all)" => redirect("/fo/users%{all}")

  mount WasteCarriersEngine::Engine => "/fo"

  mount DefraRubyMocks::Engine => "/fo/mocks"

  resource :cookies, only: %i[edit update] do
    member do
      post :accept_analytics
      post :reject_analytics
      post :hide_this_message
    end
  end

  # Some old bookmarks may no longer have active routes; route anything unmatched to the start page.
  # match "*path", :to => "waste_carriers_engine/start_forms#new", :via => :all
end
