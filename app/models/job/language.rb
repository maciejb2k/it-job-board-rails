# frozen_string_literal: true

class Job::Language < ApplicationRecord
  # Constants
  PROFICIENCY_TYPES = %w[a1 a2 b1 b2 c1 c2 native].freeze

  # Validations
  validates :name, presence: true
  validates :code, presence: true
  validates :proficiency, inclusion: {
    in: :proficiency_types,
    allow_blank: true
  }

  # Associations
  belongs_to :job_offer, class_name: 'Job::Offer'

  def proficiency_types
    PROFICIENCY_TYPES
  end
end
