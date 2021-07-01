# frozen_string_literal: true

Rails.application.routes.draw do
  root 'top#index'
  # resources :items
  resources :events
  scope :events do
    resources :users
  end
  namespace :api do # , format: 'json' do
    resources :items # , only: [:index, :create, :destroy, :update]
    resources :user_bring_items
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
