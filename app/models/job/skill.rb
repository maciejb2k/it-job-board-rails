# frozen_string_literal: true

module Job
  class Skill < ApplicationRecord
    validates :name, presence: true
    validates :level, presence: true,
                      numericality: {
                        is_integer: true,
                        in: 1..5
                      }

    belongs_to :job_offer, class_name: 'Job::Offer'
  end
end
