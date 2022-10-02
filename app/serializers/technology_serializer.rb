# frozen_string_literal: true

module Job
  class TechnologySerializer < ActiveModel::Serializer
    attributes :id, :name
  end
end
