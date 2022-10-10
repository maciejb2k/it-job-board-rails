# frozen_string_literal: true

class Job::Application < ApplicationRecord
  # Constants
  WORK_FORM_CHOICES = %w[remote hybrid stationary].freeze
  START_TIME_CHOICES = %w[now month two_months plus_two_months].freeze
  WORKING_HOURS_CHOICES = %w[full 4_5 3_4 1_2].freeze

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :work_form, inclusion: { in: :work_form_choices }
  validates :city, presence: true
  validates :cv, presence: true
  validates :contract, inclusion: { in: :contract_types }
  validates :start_time, inclusion: { in: :start_time_choices }
  validates :working_hours, inclusion: { in: :working_hours_choices }
  validate :valid_when_no_open_recruitment, on: :create

  # Associations
  belongs_to :job_offer, class_name: 'Job::Offer'

  has_many :job_application_statuses, dependent: :destroy,
                                      class_name: 'Job::ApplicationStatus',
                                      foreign_key: 'job_application_id',
                                      inverse_of: :job_application

  # Callbacks
  after_create :set_status

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

  private

  def valid_when_no_open_recruitment
    # Select all opened applications for current user
    applications =
      Job::Application
      .where(email:, job_offer_id:, closed_at: nil)
      .any?

    # OK - return if all applications are closed
    return unless applications

    # return error if any application is pending
    errors.add(:status, 'cannot apply on the same offer, when recruitment process is ongoing')
  end

  # Create status associated to application
  def set_status
    job_application_statuses.create(status: 'new')
  end
end
