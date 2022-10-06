# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :auth do
        mount_devise_token_auth_for 'Candidate', at: 'candidate'
        mount_devise_token_auth_for 'Employer', at: 'employer'
      end

      namespace :employer do
        resources :offers
      end

      namespace :job do
        resources :applications, only: %i[create]
        resources :offers, only: %i[index show]
      end
    end
  end
end
