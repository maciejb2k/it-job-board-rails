# frozen_string_literal: true

class Job::Location < ApplicationRecord
  validates :city, presence: true
  validates :street, presence: true
  validates :building_number, presence: true
  validates :zip_code, presence: true
  validates :country, presence: true
  validates :country_code, presence: true

  belongs_to :job_offer, class_name: 'Job::Offer'
end
