Rails.application.routes.draw do
  resources :items
  root 'events#index'
  resources :events
  resources :items
  namespace :api, format: 'json' do
    resources :items, only: [:index, :create, :destroy, :update]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
