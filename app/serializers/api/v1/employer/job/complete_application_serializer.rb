# frozen_string_literal: true

class Api::V1::Employer::Job::CompleteApplicationSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :email,
             :phone,
             :cv,
             :note,
             :city,
             :work_form,
             :city,
             :contract,
             :start_time,
             :working_hours,
             :closed_at,
             :starred,
             :data,
             :job_offer_id,
             :statuses

  def name
    "#{object.first_name} #{object.last_name}"
  end

  def phone
    object.phone || ''
  end

  def note
    object.note || ''
  end

  def statuses
    object.job_application_statuses.map do |item|
      Job::ApplicationStatusSerializer.new(item).attributes
    end
  end

  # Statuses
  class Job::ApplicationStatusSerializer < ActiveModel::Serializer
    attributes :status, :note, :created_at

    def note
      object.note || ''
    end
  end
end
