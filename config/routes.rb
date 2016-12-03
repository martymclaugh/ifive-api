Rails.application.routes.draw do
  devise_for :user, only: []
  resource :users
  resources :phone_numbers, only: [:new, :create]
  namespace :v1, defaults: { format: :json } do
    resource :login, only: [:create], controller: :sessions
  end
end
