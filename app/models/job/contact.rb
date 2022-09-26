# frozen_string_literal: true

module Job
  class Contact < ApplicationRecord
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :phone, numericality: { only_integer: true }

    belongs_to :job_offer
  end
end
