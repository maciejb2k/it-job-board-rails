# frozen_string_literal: true

module Job
  class CategorySerializer < ActiveModel::Serializer
    attributes :id, :name
  end
end
