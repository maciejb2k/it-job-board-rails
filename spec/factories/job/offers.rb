# frozen_string_literal: true

FactoryBot.define do
  factory :job_offer, class: 'Job::Offer' do
    title { 'Software Enginner' }
    seniority { rand(1..5) }
    body { 'XD' }
    valid_until { Time.zone.now + 86400 }
    category
    technology

    after(:build) do |job_offer|
      job_offer.job_skills << build(:job_skill, job_offer: job_offer)
      job_offer.job_contracts << build(:job_contract, job_offer: job_offer)
      job_offer.job_locations << build(:job_location, job_offer: job_offer)
      job_offer.job_languages << build(:job_language, job_offer: job_offer)
      job_offer.job_equipment << build(:job_equipment, job_offer: job_offer)
    end
  end
end
