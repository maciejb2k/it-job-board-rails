# frozen_string_literal: true

FactoryBot.define do
  factory :job_location, class: 'Job::Location' do
    city { 'Rzeszow' }
    street { 'Pigonia' }
    building_number { '4' }
    zip_code { '35-000' }
    country { 'Polska' }
    country_code { 'PLN' }
    job_offer
  end
end
