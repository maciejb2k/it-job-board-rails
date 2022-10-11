# frozen_string_literal: true

class Job::Equipment < ApplicationRecord
  # Validations
  validates :computer, presence: true
  validates :monitor, presence: true,
                      numericality: {
                        only_integer: true,
                        greater_than_or_equal_to: 1,
                        less_than_or_equal_to: 8
                      }

  # Associations
  belongs_to :job_offer, class_name: 'Job::Offer'
end
