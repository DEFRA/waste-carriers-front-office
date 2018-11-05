Rails.application.routes.draw do

  root to: "application#redirect_root_to_dashboard"

  devise_for :users,
             controllers: { sessions: "sessions" },
             path: "/fo/users",
             path_names: { sign_in: "sign_in", sign_out: "sign_out" },
             skip: [:invitations]

  as :user do
    get   "/fo/users/invitation/accept" => "devise/invitations#edit", as: :accept_user_invitation
    patch "/fo/users/invitation/accept" => "devise/invitations#update", as: :user_invitation
    put   "/fo/users/invitation/accept" => "devise/invitations#update"
  end

  get "/fo" => "dashboards#index"

  mount WasteCarriersEngine::Engine => "/fo"
end
