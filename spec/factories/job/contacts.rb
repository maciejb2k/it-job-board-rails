# frozen_string_literal: true

FactoryBot.define do
  factory :job_contact, class: 'Job::Contact' do

    job_offer
  end
end
