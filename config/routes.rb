Rails.application.routes.draw do

  devise_for :users
  root 'home#index', to: 'homes#index'
  resources :forecasts, only: [:index]
  resources :locations, only: [:show]
  resources :alerts, only: [:new, :create]

  #API routing
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :locations, only: [:index, :show]
    end
  end

end
