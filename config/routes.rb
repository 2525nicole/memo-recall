# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :categories, except: :show

  root 'memories#random'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  get 'up' => 'rails/health#show', as: :rails_health_check
end
