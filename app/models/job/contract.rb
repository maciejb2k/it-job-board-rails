# frozen_string_literal: true

class Job::Contract < ApplicationRecord
  # Constants
  CONTRACT_TYPES = %w[b2b uop contract mandatory].freeze

  # Validations
  validates :employment, presence: true,
                         inclusion: {
                           in: :contract_types
                         }
  validates :from, presence: true,
                   numericality: {
                     greater_than_or_equal_to: 0,
                     less_than: BigDecimal(10**6)
                   },
                   format: { with: /\A\d{1,6}(\.\d{1,2})?\z/ }
  validates :to, presence: true,
                 numericality: {
                   greater_than_or_equal_to: 0,
                   less_than: BigDecimal(10**6)
                 },
                 format: { with: /\A\d{1,6}(\.\d{1,2})?\z/ }
  validates :currency, presence: true
  validates :payment_period, presence: true

  # Enums
  enum payment_period: {
    hourly: 'hourly',
    daily: 'daily',
    monthly: 'monthly',
    yearly: 'yearly'
  }, _suffix: true, _default: 'monthly'

  # Associations
  belongs_to :job_offer, class_name: 'Job::Offer'

  def contract_types
    CONTRACT_TYPES
  end
end
