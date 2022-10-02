# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :auth do
    mount_devise_token_auth_for 'Employer', at: 'employer'
  end

  namespace :job do
    resources :offers
  end
end
