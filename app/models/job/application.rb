# frozen_string_literal: true

class Job::Application < ApplicationRecord
  WORK_FORM_CHOICES = %w[remote hybrid stationary].freeze
  START_TIME_CHOICES = %w[now month two_months plus_two_months].freeze
  WORKING_HOURS_CHOICES = %w[full 4_5 3_4 1_2].freeze
  APPLICATION_STATUSES = %w[new in_progress rejected hired resigned].freeze

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :work_form, inclusion: { in: :work_form_choices }
  validates :city, presence: true
  validates :contract, inclusion: { in: :contract_types }
  validates :start_time, inclusion: { in: :start_time_choices }
  validates :working_hours, inclusion: { in: :working_hours_choices }
  validates :status, inclusion: { in: :application_statuses, allow_blank: true }

  before_create :set_default_values

  def set_default_values
    self.status ||= 'new'
  end

  def work_form_choices
    WORK_FORM_CHOICES
  end

  def start_time_choices
    START_TIME_CHOICES
  end

  def working_hours_choices
    WORKING_HOURS_CHOICES
  end

  def contract_types
    Job::Contract::CONTRACT_TYPES
  end

  def application_statuses
    APPLICATION_STATUSES
  end
end
