# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    get 'states', to: 'states#index'
    get 'states/:id/cities', to: 'cities#index'
    get 'cities/:id', to: 'cities#show'

    namespace :session do
      # resources :registration
      post 'registration', to: 'registration#create'
      delete 'registration', to: 'registration#destroy'
    end
  end
  root 'pages#index'
  get '*path', to: 'pages#index'
end
