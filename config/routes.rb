# frozen_string_literal: true

Rails.application.routes.draw do

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
  # rubocop:disable Style/FormatStringToken
  get "/users(*all)" => redirect("/fo/users%{all}")
  # rubocop:enable Style/FormatStringToken

  mount WasteCarriersEngine::Engine => "/fo"

  mount DefraRubyMocks::Engine => "/fo/mocks"
end
