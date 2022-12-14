# frozen_string_literal: true

module Orderable
  extend ActiveSupport::Concern

  # A list of the param names that can be used for ordering the model list
  def ordering_params(params, model_name)
    # For example it retrieves a list of experiences in descending order of price.
    # Within a specific price, older experiences are ordered first
    #
    # GET /api/v1/experiences?sort=-price,created_at
    # ordering_params(params) # => { price: :desc, created_at: :asc }
    # Experience.order(price: :desc, created_at: :asc)
    #

    return unless params[:sort]

    sort_order = { '+' => :asc, '-' => :desc }
    sorted_params = params[:sort].split(',')
    # controllers are namespaced, and models are not
    model = model_name.classify.constantize

    ordering = {}
    sorted_params.each do |attr|
      sort_sign = /\A[+-]/.match?(attr) ? attr.slice!(0) : '+'
      ordering[attr] = sort_order[sort_sign] if model.attribute_names.include?(attr)
    end

    ordering
  end
end
