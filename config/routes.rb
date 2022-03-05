# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    resources :states
  end
  root 'pages#index'
  get '*path', to: 'pages#index'
end
