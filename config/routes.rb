# frozen_string_literal: true

Rails.application.routes.draw do
  root 'top#index'
  get '/top/tos', to: 'top#tos'
  resources :events, only: %i[index show new edit]
  scope :events do
    resources :users, only: %i[create new]
  end
  namespace :api do
    resources :items, only: %i[show destroy]
    resources :user_bring_items, only: %i[create destroy update]
    resources :events, only: %i[create update]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
