# frozen_string_literal: true

Rails.application.routes.draw do
  resources :quotes
  resources :users
  post 'user_auth', to: 'auth#user_auth'
  post 'quotes/:tag', to:'quotes#search_quotes_by_tag'
end
