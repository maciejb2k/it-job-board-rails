# frozen_string_literal: true

class Job::Contact < ApplicationRecord
  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Associations
  belongs_to :job_offer, class_name: 'Job::Offer'
end
