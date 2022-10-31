# frozen_string_literal: true

class Api::V1::Candidate::Job::CompleteApplicationSerializer < ActiveModel::Serializer
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
             :statuses,
             :job_offer

  def statuses
    object.job_application_statuses.map do |item|
      Job::ApplicationStatusSerializer.new(item).attributes
    end
  end

  def job_offer
    Job::OfferSerializer.new(object.job_offer).attributes
  end

  def name
    "#{object.first_name} #{object.last_name}"
  end

  # Job::Offer
  class Job::OfferSerializer < ActiveModel::Serializer
    attributes :id, :title, :valid_until
  end

  # Job::ApplicationStatus
  class Job::ApplicationStatusSerializer < ActiveModel::Serializer
    attributes :status, :note, :created_at

    def note
      object.note || ''
    end
  end
end
