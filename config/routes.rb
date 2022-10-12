# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'Candidate', at: 'candidate'
      mount_devise_token_auth_for 'Employer', at: 'employer'

      devise_scope :employer do
        namespace :employer do
          namespace :job do
            resources :offers
            resources :applications do
              member do
                post :update_status
                put :close
              end
            end
          end
        end
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
