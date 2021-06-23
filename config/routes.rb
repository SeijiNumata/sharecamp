Rails.application.routes.draw do
  root 'events#index'
  resources :items
  resources :events
  namespace :api, format: 'json' do
    resources :items, only: [:index, :create, :destroy, :update]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
