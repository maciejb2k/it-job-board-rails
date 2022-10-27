# frozen_string_literal: true

class CandidateDetail < ApplicationRecord
  # Validations
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
                            greater_than_or_equal_to: 0,
                            only_integer: true
                          }
  validates :salary_to, presence: true,
                        numericality: {
                          greater_than_or_equal_to: 0,
                          only_integer: true
                        }
  validates :candidate, uniqueness: true
  validate :valid_when_salary_from_is_less_than_salary_to, on: %i[create update]

  # Associations
  belongs_to :candidate

  def valid_when_salary_from_is_less_than_salary_to
    return unless salary_from.present? && salary_to.present? && salary_from >= salary_to

    errors.add('salary', 'starting salary must be greater than ending salary')
  end
end
