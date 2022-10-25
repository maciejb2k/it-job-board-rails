# frozen_string_literal: true

FactoryBot.define do
  factory :job_contract, class: 'Job::Contract' do
    employment { 'uop' }
    from { rand(5000..8000) }
    to { rand(10000..15000) }
    currency { 'pln' }
    payment_period { 'monthly' }
    job_offer
  end
end
