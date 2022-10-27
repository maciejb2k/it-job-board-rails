# frozen_string_literal: true

FactoryBot.define do
  factory :candidate_detail do
    location { 'Rzeszow' }
    seniority { rand(1..5) }
    status { 'looking for job' }
    position { 'Ruby on Rails Developer' }
    specialization { 'backend' }
    salary_from { rand(3000..5000) }
    salary_to { rand(7000..9000) }
    candidate
  end
end
