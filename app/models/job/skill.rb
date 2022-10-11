# frozen_string_literal: true

class Job::Skill < ApplicationRecord
  # Validations
  validates :name, presence: true
  validates :level, presence: true,
                    numericality: {
                      only_integer: true,
                      greater_than_or_equal_to: 1,
                      less_than_or_equal_to: 5
                    }

  # Associtations
  belongs_to :job_offer, class_name: 'Job::Offer'

  # Scopes
  scope :only_required, -> { where(optional: false) }
end
