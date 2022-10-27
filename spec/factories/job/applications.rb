# frozen_string_literal: true

FactoryBot.define do
  factory :job_application, class: 'Job::Application' do
    first_name { 'Maciej' }
    last_name { 'Biel' }
    email { 'maciek.b2k@gmail.com' }
    work_form { 'stationary' }
    city { 'rzeszow' }
    cv { 'blob' }
    contract { 'uop' }
    start_time { 'now' }
    working_hours { 'full' }

    job_offer
  end
end
