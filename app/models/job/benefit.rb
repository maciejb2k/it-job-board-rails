# frozen_string_literal: true

class Job::Benefit < ApplicationRecord
  validates :group, presence: true
  validates :name, presence: true

  belongs_to :job_offer, class_name: 'Job::Offer'
end
