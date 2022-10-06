# frozen_string_literal: true

class Api::V1::Job::CompleteOfferSerializer < ActiveModel::Serializer
  attributes :id,
             :title,
             :slug,
             :seniority,
             :valid_until,
             :is_active,
             :remote,
             :ua_supported,
             :travelling
end
