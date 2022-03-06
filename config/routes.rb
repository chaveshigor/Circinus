# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :session do
      # resources :auth
      post 'registration', to: 'registration#create'
      put 'registration/:user_id/:confirmation_token', to: 'registration#confirmate_account'
      post 'auth', to: 'auth#create'
    end

    get 'states', to: 'states#index'
    get 'states/:id/cities', to: 'cities#index'
    get 'cities/:id', to: 'cities#show'
  end
  root 'pages#index'
  get '*path', to: 'pages#index'
end
