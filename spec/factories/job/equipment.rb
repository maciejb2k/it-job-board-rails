# frozen_string_literal: true

FactoryBot.define do
  factory :job_equipment, class: 'Job::Equipment' do
    computer { 'MacBook' }
    monitor { 2 }
    job_offer
  end
end
