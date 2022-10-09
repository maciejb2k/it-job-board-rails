# frozen_string_literal: true

class Job::Company < ApplicationRecord
  DATA_SCHEMA = Rails.root.join('config/schemas/job/company/data.json')

  # Validations
  validates :name, presence: true
  validates :logo, presence: true
  validates :size, presence: true, numericality: {
    greater_than_or_equal_to: 0,
    only_integer: true
  }
  validates :data, json: {
    message: ->(errors) { errors },
    schema: DATA_SCHEMA
  }

  # Associations
  belongs_to :job_offer, class_name: 'Job::Offer'
end
