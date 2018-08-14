Rails.application.routes.draw do

  root to: "application#redirect_root_to_dashboard"

  devise_for :users, path: "/fo/users", path_names: { sign_in: "sign_in", sign_out: "sign_out" }

  get "/fo" => redirect(Rails.configuration.wcrs_frontend_url)

  mount WasteCarriersEngine::Engine => "/fo"
end
