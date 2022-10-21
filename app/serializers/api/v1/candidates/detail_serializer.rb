# frozen_string_literal: true

class Api::V1::Candidates::DetailSerializer < ActiveModel::Serializer
  attributes :id,
             :photo,
             :location,
             :seniority,
             :status,
             :specialization,
             :position,
             :salary_from,
             :salary_to,
             :hide_salary,
             :industry,
             :carrer_path,
             :technology,
             :created_at
end
