# frozen_string_literal: true

module Job
  class Contract < ApplicationRecord
    validates :type, presence: true
    validates :hide_salary, presence: true, inclusion: [true, false]
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

    belongs_to :job_offer
  end
end
