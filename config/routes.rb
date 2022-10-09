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
        resources :offers do
          member do
            post :apply
          end
        end
      end
    end
  end
end
