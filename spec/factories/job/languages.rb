# frozen_string_literal: true

FactoryBot.define do
  factory :job_language, class: 'Job::Language' do
    name { 'french' }
    code { 'FR' }
    proficiency { 'native' }
    job_offer
  end
end
