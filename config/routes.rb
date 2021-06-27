# frozen_string_literal: true

Rails.application.routes.draw do
  root 'top#index'
  # resources :items
  resources :events
  namespace :api do # , format: 'json' do
    resources :items # , only: [:index, :create, :destroy, :update]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
