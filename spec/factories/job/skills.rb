# frozen_string_literal: true

FactoryBot.define do
  factory :job_skill, class: 'Job::Skill' do
    name { 'Ruby' }
    level { rand(1..5) }
    job_offer
  end
end
