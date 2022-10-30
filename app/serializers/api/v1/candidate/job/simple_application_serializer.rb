# frozen_string_literal: true

class Api::V1::Candidate::Job::SimpleApplicationSerializer < ActiveModel::Serializer
  attributes :id,
             :status,
             :job_offer

  def status
    object.job_application_statuses.last.status
  end

  def job_offer
    Job::OfferSerializer.new(object.job_offer).attributes
  end

  def name
    "#{object.first_name} #{object.last_name}"
  end

  # Job::Offer
  class Job::OfferSerializer < ActiveModel::Serializer
    attributes :id, :title
  end
end
