# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  namespace :job do
    resources :offers do
      resources :skills, only: [:destroy]
    end
  end
end
