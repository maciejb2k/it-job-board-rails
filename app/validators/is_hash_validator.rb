# frozen_string_literal: true

class IsHashValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, 'must be an hash') unless value.is_a? Hash
  end
end
