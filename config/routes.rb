Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # 

  get '/api/v1/items/find', to: 'api/v1/items/name_search#show'
  get '/api/v1/items/find_all', to: 'api/v1/items/name_search#index'

  get '/api/v1/merchants/find', to: 'api/v1/merchants/search#show'

  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: :merchant_items
      end

      resources :items do
        resources :merchant, only: [:index], controller: :items_merchant
      end
    end
  end
end
