# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :categories, expect: [:show] do
    resources :memories, only: [:index], controller: 'category_memories'
  end

  namespace :memories do
    resource :random, only: [:show]
  end

  resources :memories, except: [:show]

  authenticated :user do
    root 'memories/random#show', as: :authenticated_root
  end

  root 'welcome#index'

  get 'pp', to: 'welcome#pp', as: :pp
  get 'tos', to: 'welcome#tos', as: :tos
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  get 'up' => 'rails/health#show', as: :rails_health_check
end
