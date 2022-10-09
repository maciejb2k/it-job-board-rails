# frozen_string_literal: true

class Job::Benefit < ApplicationRecord
  # Validations
  validates :group, presence: true
  validates :name, presence: true

  # Associations
  belongs_to :job_offer, class_name: 'Job::Offer'
end
