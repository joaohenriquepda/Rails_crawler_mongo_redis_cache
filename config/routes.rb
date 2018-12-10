# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users
  post 'user_auth', to: 'auth#user_auth'

  get 'quotes/:tag', to:'crawler_quotes#crawler_data'
end
