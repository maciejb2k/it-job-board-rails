# frozen_string_literal: true

module Job
  class Offer < ApplicationRecord
    DATA_SCHEMA = Rails.root.join('config/schemas/job/offer/data.json')
    TRAVELLING_TYPES = %w[none some a_lot].freeze

    validates :title, presence: true
    validates :seniority, presence: true,
                          numericality: {
                            only_integer: true,
                            greater_than_or_equal_to: 1,
                            less_than_or_equal_to: 4
                          }
    validates :body, presence: true
    validates :valid_until, presence: true
    validates :remote, presence: true,
                       numericality: {
                         only_integer: true,
                         greater_than_or_equal_to: 0,
                         less_than_or_equal_to: 5
                       }
    validates :data, json: {
      message: ->(errors) { errors },
      schema: DATA_SCHEMA
    }
    validate :valid_until_cannot_be_in_past
    validates :travelling, presence: true,
                           inclusion: { in: :travelling_types }

    has_many :job_skills, dependent: :destroy, class_name: 'Job::Skill',
                          foreign_key: 'job_offer_id', inverse_of: :job_offer
    has_many :job_benefits, dependent: :destroy, class_name: 'Job::Benefit',
                            foreign_key: 'job_offer_id', inverse_of: :job_offer
    has_many :job_contracts, dependent: :destroy, class_name: 'Job::Contract',
                             foreign_key: 'job_offer_id', inverse_of: :job_offer
    has_many :job_locations, dependent: :destroy, class_name: 'Job::Location',
                             foreign_key: 'job_offer_id', inverse_of: :job_offer
    has_many :job_contacts, dependent: :destroy, class_name: 'Job::Contact',
                            foreign_key: 'job_offer_id', inverse_of: :job_offer
    has_many :job_languages, dependent: :destroy, class_name: 'Job::Language',
                             foreign_key: 'job_offer_id', inverse_of: :job_offer
    has_one :job_equipment, dependent: :destroy, class_name: 'Job::Equipment',
                            foreign_key: 'job_offer_id', inverse_of: :job_offer
    has_one :job_companies, dependent: :destroy, class_name: 'Job::Company',
                            foreign_key: 'job_offer_id', inverse_of: :job_offer

    belongs_to :category
    belongs_to :technology
    belongs_to :user

    validates :job_skills,
              :job_contracts,
              :job_locations,
              :job_companies,
              :job_equipment,
              :job_languages, presence: true

    accepts_nested_attributes_for :job_companies,
                                  :job_equipment

    accepts_nested_attributes_for :job_skills,
                                  :job_benefits,
                                  :job_contracts,
                                  :job_locations,
                                  :job_contacts,
                                  :job_languages, allow_destroy: true

    validates_associated :job_skills,
                         :job_benefits,
                         :job_contracts,
                         :job_locations,
                         :job_companies,
                         :job_contacts,
                         :job_languages,
                         :job_equipment

    after_validation :set_slug, only: %i[create update]

    def to_param
      "#{id}-#{slug}"
    end

    def travelling_types
      TRAVELLING_TYPES
    end

    private

    def valid_until_cannot_be_in_past
      return unless valid_until.present? && valid_until < Time.zone.today

      errors.add(:valid_until, "can't be in the past")
    end

    def set_slug
      self.slug = title.to_s.parameterize
    end
  end
end
