# frozen_string_literal: true

class Employer < ApplicationRecord
  extend Devise::Models
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :job_offers, class_name: 'Job::Offer', dependent: :destroy, foreign_key: 'employer_id', inverse_of: :employer
end
