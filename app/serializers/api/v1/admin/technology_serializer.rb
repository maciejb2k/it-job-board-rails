# frozen_string_literal: true

class Api::V1::Admin::TechnologySerializer < ActiveModel::Serializer
  attributes :id, :name
end
