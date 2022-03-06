# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :session do
      post 'registration', to: 'registration#create'
      delete 'registration', to: 'registration#destroy'
      put 'registration/:user_id/:confirmation_token', to: 'registration#confirmate_account'
      post 'auth', to: 'auth#create'
      # resources :auth
    end

    get 'states', to: 'states#index'
    get 'states/:id/cities', to: 'cities#index'
    get 'cities/:id', to: 'cities#show'

    resources :profiles
  end
  root 'pages#index'
  get '*path', to: 'pages#index'
end
