Rails.application.routes.draw do
  devise_for :user, only: []
  resources :users
  resources :phone_numbers, only: [:new, :create, :update]
  namespace :v1, defaults: { format: :json } do
    resource :login, controller: :sessions
  end
end
