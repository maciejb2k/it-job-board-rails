# frozen_string_literal: true

class Job::Offer < ApplicationRecord
  # Constants
  DATA_SCHEMA = Rails.root.join('config/schemas/job/offer/data.json')
  TRAVELLING_TYPES = %w[none some a_lot].freeze

  # Validations
  validates :title, presence: true
  validates :seniority, presence: true,
                        numericality: {
                          only_integer: true,
                          greater_than_or_equal_to: 1,
                          less_than_or_equal_to: 4
                        }
  validates :body, presence: true
  validates :valid_until, presence: true
  validates :travelling, inclusion: { in: :travelling_types, allow_blank: true }
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

  # Directly related to Job::Offer, not independent
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

  # Associations
  has_many :job_applications, dependent: :destroy, class_name: 'Job::Application',
                              foreign_key: 'job_offer_id', inverse_of: :job_offer

  # For Job::SimpleOfferSerializer to display only required skills
  has_many :job_skills_required,
           -> { only_required },
           dependent: :destroy,
           class_name: 'Job::Skill',
           foreign_key: 'job_offer_id',
           inverse_of: :job_offer

  belongs_to :category
  belongs_to :technology
  belongs_to :employer

  # Validates whether at least one record was provided
  validates :job_skills,
            :job_contracts,
            :job_locations,
            :job_companies,
            :job_equipment,
            :job_languages, presence: true

  # Only updating
  accepts_nested_attributes_for :job_companies,
                                :job_equipment

  # Updating & deleting
  accepts_nested_attributes_for :job_skills,
                                :job_benefits,
                                :job_contracts,
                                :job_locations,
                                :job_contacts,
                                :job_languages, allow_destroy: true

  # Validation of nested attributes
  validates_associated :job_skills,
                       :job_benefits,
                       :job_contracts,
                       :job_locations,
                       :job_companies,
                       :job_contacts,
                       :job_languages,
                       :job_equipment

  # Scopes for filtering
  scope :is_active, ->(*) { where('valid_until > ? AND is_active = ?', Time.zone.now, true) }
  scope :is_interview_online, ->(value = true) { where(interview_online: value) }
  scope :is_ua_supported, ->(value = false) { where(ua_supported: value) }
  scope :by_category, lambda { |categories|
    left_joins(:category)
      .where('category.name': categories)
  }
  scope :by_technology, lambda { |technologies|
    left_joins(:technology)
      .where('technology.name': technologies)
  }
  scope :by_remote, ->(remote) { where(remote:) }
  scope :by_seniority, ->(seniority) { where(seniority:) }
  scope :by_travelling, ->(travelling) { where(travelling:) }
  scope :by_city, ->(cities) { joins(:job_locations).where('job_locations.city': cities) }
  scope :by_currency, lambda { |currencies|
    left_joins(:job_contracts)
      .where('job_contracts.currency': currencies)
  }
  scope :by_employment, lambda { |employments|
    left_joins(:job_contracts)
      .where('job_contracts.employment': employments)
  }
  scope :by_language, lambda { |languages|
    left_joins(:job_languages)
      .where('job_languages.name': languages)
  }
  scope :by_salary, lambda { |from, to|
    left_joins(:job_contracts)
      .where('job_contracts.from >= ? AND job_contracts.to <= ?', from, to)
  }
  scope :by_skill, lambda { |skills|
    left_joins(:job_skills)
      .where('job_skills.name': skills)
  }

  # Callbacks
  after_validation :set_slug, only: %i[create update]
  before_create :set_default_values

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

  def set_default_values
    self.travelling = 'none'
  end
end
