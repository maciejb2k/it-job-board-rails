# frozen_string_literal: true

module Job
  class Offer < ApplicationRecord
    validates :title, presence: true
    validates :seniority, presence: true, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 4
    }
    validates :body, presence: true
    validates :valid_until, presence: true
    validates :status, presence: true
    validates :remote, presence: true, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 5
    }
    validates :hybrid, presence: true, inclusion: [true, false]
    validates :interview_online, presence: true, inclusion: [true, false]
    validate :valid_until_cannot_be_in_past

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

    belongs_to :category
    belongs_to :technology

    private

    def valid_until_cannot_be_in_past
      return unless valid_until.present? && valid_until < Time.zone.today

      errors.add(:valid_until, "can't be in the past")
    end
  end
end
