Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      get 'merchants/find', to: 'merchants#find'
      resources :merchants, only: %i[index show] do
        resources :items, only: %i[index], to: 'merchant_items#index'
      end
      get '/items/find_all', to: 'items#find_all'
      resources :items, only: %i[index show create update destroy] do
        resources :merchant, only: %i[index], to: 'item_merchant#index'
      end
    end
  end
end
