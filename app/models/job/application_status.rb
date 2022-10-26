# frozen_string_literal: true

class Job::ApplicationStatus < ApplicationRecord
  # Constants
  APPLICATION_STATUSES = %w[new in_progress rejected hired resigned].freeze

  # Validations
  validates :status, inclusion: { in: :application_statuses }
  validates :status, uniqueness: { # prevent inserting same status twice
    scope: %i[job_application_id],
    message: 'cannot set the same status twice'
  }
  validate :check_status

  # Associations
  belongs_to :job_application, class_name: 'Job::Application'

  # Callbacks
  after_save :update_application

  def application_statuses
    APPLICATION_STATUSES
  end

  private

  # Check wheteher application is closed
  def check_status
    if job_application.present? && job_application.job_application_statuses.where(
      status: %w[rejected hired resigned]
    ).any?
      errors.add(:status, 'cannot update status, if application is closed')
    end
  end

  # Update parent model after closing application
  def update_application
    job_application.update(closed_at: Time.zone.now) if %w[rejected hired resigned].include? status
  end
end
