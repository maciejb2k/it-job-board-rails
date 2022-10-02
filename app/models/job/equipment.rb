# frozen_string_literal: true

module Job
  class Equipment < ApplicationRecord
    validates :computer, presence: true
    validates :monitor, presence: true,
                        numericality: {
                          only_integer: true,
                          greater_than_or_equal_to: 1,
                          less_than_or_equal_to: 8
                        }

    belongs_to :job_offer, class_name: 'Job::Offer'
  end
end
