# frozen_string_literal: true

class Api::V1::Employer::Job::SimpleApplicationSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :email,
             :starred,
             :status

  def status
    Job::ApplicationStatusSerializer.new(
      object.job_application_statuses.last
    ).attributes
  end

  def name
    "#{object.first_name} #{object.last_name}"
  end

  # Skills
  class Job::ApplicationStatusSerializer < ActiveModel::Serializer
    attributes :status, :note

    def note
      object.note || ''
    end
  end
end
