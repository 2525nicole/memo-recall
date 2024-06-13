# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :category, expect: [:show] do
    resources :memories, only: [:index], controller: 'category_memories'
    member do
      delete :destroy_with_memories
    end
  end

  resources :memories, except: [:show]

  root 'memories#random'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  get 'up' => 'rails/health#show', as: :rails_health_check
end
