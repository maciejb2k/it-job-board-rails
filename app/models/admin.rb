# frozen_string_literal: true

class Admin < ApplicationRecord
  extend Devise::Models
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :validatable
  include DeviseTokenAuth::Concerns::User
end
