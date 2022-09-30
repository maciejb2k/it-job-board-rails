# frozen_string_literal: true

class IsArrayValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, 'must be an array') unless value.is_a? Array
  end
end
