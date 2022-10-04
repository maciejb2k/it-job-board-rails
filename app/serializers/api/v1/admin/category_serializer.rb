# frozen_string_literal: true

class Api::V1::Admin::CategorySerializer < ActiveModel::Serializer
  attributes :id, :name
end
