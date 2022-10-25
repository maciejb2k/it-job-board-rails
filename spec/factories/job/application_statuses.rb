# frozen_string_literal: true

FactoryBot.define do
  factory :job_application_status, class: 'Job::ApplicationStatus' do
    job_application
    status { 'new' }
    note { '' }
  end
end
