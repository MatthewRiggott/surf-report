Rails.application.routes.draw do

  root 'welcome#index'

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :locations, only: [:index, :show]
    end
  end

end
