# frozen_string_literal: true

class Job::Contract < ApplicationRecord
  # Constants
  CONTRACT_TYPES = %w[b2b uop contract mandatory].freeze
  PAYMENT_TYPES = %w[hourly daily monthly yearly].freeze

  # Validations
  validates :employment, inclusion: { in: :contract_types }
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
  validates :payment_period, inclusion: { in: :payment_types }
  validate :valid_when_from_is_less_than_to

  # Associations
  belongs_to :job_offer, class_name: 'Job::Offer'

  def contract_types
    CONTRACT_TYPES
  end

  def payment_types
    PAYMENT_TYPES
  end

  def valid_when_from_is_less_than_to
    return unless from.present? && to.present? && from >= to

    errors.add('salary', 'starting salary must be greater than ending salary')
  end
end
