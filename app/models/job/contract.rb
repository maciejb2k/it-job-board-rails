# frozen_string_literal: true

module Job
  class Contract < ApplicationRecord
    CONTRACT_TYPES = %w[b2b uop contract mandatory].freeze

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

    belongs_to :job_offer, class_name: 'Job::Offer'

    def contract_types
      CONTRACT_TYPES
    end
  end
end
