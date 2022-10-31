# frozen_string_literal: true

FactoryBot.define do
  factory :job_benefit, class: 'Job::Benefit' do
    group { 'office' }
    name { 'free food' }
    job_offer
  end
end
