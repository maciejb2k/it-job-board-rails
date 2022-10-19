# frozen_string_literal: true

class Candidate < ApplicationRecord
  extend Devise::Models
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :job_applications, dependent: :nullify, class_name: 'Job::Application',
                              inverse_of: :candidate
  has_one :candidate_info, dependent: :destroy, inverse_of: :candidate
end
