Rails.application.routes.draw do
  mount WasteCarriersEngine::Engine => "/"

  root "waste_carriers_engine/registrations#index"

  devise_for :users
  devise_scope :user do
    get "/users/sign_out" => "devise/sessions#destroy"
  end
end
