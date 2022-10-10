# frozen_string_literal: true

class Api::V1::Job::ApplicationSerializer < ActiveModel::Serializer
  attributes :id,
             :job_offer_id,
             :first_name,
             :last_name,
             :email,
             :phone,
             :cv,
             :note,
             :work_form,
             :city,
             :contract,
             :start_time,
             :working_hours,
             :closed_at
end
