# frozen_string_literal: true

module Job
  class Skill < ApplicationRecord
    validates :name, presence: true
    validates :level, presence: true,
                      numericality: {
                        only_integer: true,
                        greater_than_or_equal_to: 1,
                        less_than_or_equal_to: 5
                      }

    belongs_to :job_offer, class_name: 'Job::Offer'
  end
end
