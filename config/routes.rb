# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users
  post 'user_auth', to: 'auth#user_auth'
end
