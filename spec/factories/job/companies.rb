# frozen_string_literal: true

FactoryBot.define do
  factory :job_company, class: 'Job::Company' do
    name { 'W goracej wodzie company' }
    logo { 'url' }
    size { 100 }
    job_offer
  end
end
