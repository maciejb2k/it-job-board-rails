# frozen_string_literal: true

class CandidateInfo < ApplicationRecord
  validates :location, presence: true
  validates :seniority, presence: true,
                        numericality: {
                          only_integer: true,
                          greater_than_or_equal_to: 1,
                          less_than_or_equal_to: 5
                        }
  validates :status, presence: true
  validates :specialization, presence: true
  validates :position, presence: true
  validates :salary_from, presence: true,
                          numericality: {
                            greater_than_or_equal_to: 0
                          }
  validates :salary_to, presence: true,
                        numericality: {
                          greater_than_or_equal_to: 0
                        }

  belongs_to :candidate
end
