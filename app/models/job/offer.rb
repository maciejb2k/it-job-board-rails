# frozen_string_literal: true

module Job
  class Offer < ApplicationRecord
    has_many :job_skills, dependent: :destroy, class_name: 'Job::Skill',
                          foreign_key: 'job_offer_id', inverse_of: :job_offer
    has_many :job_benefits, dependent: :destroy, class_name: 'Job::Benefit',
                            foreign_key: 'job_offer_id', inverse_of: :job_offer
    has_many :job_contracts, dependent: :destroy, class_name: 'Job::Contract',
                             foreign_key: 'job_offer_id', inverse_of: :job_offer
    has_many :job_locations, dependent: :destroy, class_name: 'Job::Location',
                             foreign_key: 'job_offer_id', inverse_of: :job_offer
    has_many :job_companies, dependent: :destroy, class_name: 'Job::Company',
                             foreign_key: 'job_offer_id', inverse_of: :job_offer
    has_many :job_contacts, dependent: :destroy, class_name: 'Job::Contact',
                            foreign_key: 'job_offer_id', inverse_of: :job_offer
    has_many :job_languages, dependent: :destroy, class_name: 'Job::Language',
                             foreign_key: 'job_offer_id', inverse_of: :job_offer
  end
end
