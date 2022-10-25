# frozen_string_literal: true

FactoryBot.define do
  factory :job_application_status, class: 'Job::ApplicationStatus' do
    job_application
    note { '' }

    trait :new do
      status { 'new' }
    end

    trait :in_progress do
      status { 'in_progress' }
    end

    trait :hired do
      status { 'hired' }
    end
    
    trait :rejected do
      status { 'rejected' }
    end
    
    trait :resigned do
      status { 'resigned' }
    end

    factory :new_job_application_status, traits: %i[new]
    factory :in_progress_job_application_status, traits: %i[in_progress]
    factory :hired_job_application_status, traits: %i[hired]
    factory :rejected_job_application_status, traits: %i[rejected]
    factory :resigned_job_application_status, traits: %i[resigned]
  end
end
