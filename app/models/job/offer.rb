# frozen_string_literal: true

module Job
  class Offer < ApplicationRecord
    has_many :job_skills, dependent: :destroy
    has_many :job_benefits, dependent: :destroy
    has_many :job_contracts, dependent: :destroy
    has_many :job_locations, dependent: :destroy
    has_many :job_companies, dependent: :destroy
    has_many :job_contacts, dependent: :destroy
    has_many :job_languages, dependent: :destroy
  end
end
