# frozen_string_literal: true

FactoryBot.define do
  factory :candidate do
    uid { SecureRandom.uuid }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { "#{first_name}.#{last_name}@#{SecureRandom.uuid}.com" }
    password { 'password' }
  end
end
