# frozen_string_literal: true

class Technology < ApplicationRecord
  validates :name, presence: true

  has_many :job_offers, class_name: 'Job::Offer', dependent: :nullify
end
