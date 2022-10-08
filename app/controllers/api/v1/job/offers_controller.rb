# frozen_string_literal: true

class Api::V1::Job::OffersController < ApplicationController
  before_action :set_offer, except: %i[index]
  after_action { pagy_headers_merge(@pagy) if @pagy }

  with_options only: :index do
    has_scope :is_active, default: nil, allow_blank: true
    has_scope :is_interview_online, type: :boolean, allow_blank: true
    has_scope :is_ua_supported, type: :boolean, allow_blank: true
    has_scope :by_title
    has_scope :by_category
    has_scope :by_technology
    has_scope :by_remote
    has_scope :by_travelling
    has_scope :by_city
    has_scope :by_seniority
    has_scope :by_currency
    has_scope :by_employment
    has_scope :by_language
    has_scope :by_salary, using: %i[from to]
  end

  def index
    eager_load_associations = %i[
      category technology job_skills_required
      job_languages job_contracts job_locations
    ]

    @pagy, @offers = pagy(
      apply_scopes(
        Job::Offer
      ).includes(eager_load_associations).all
    )

    render json: @offers,
           each_serializer: Api::V1::Job::SimpleOfferSerializer
  end

  private

  def set_offer
    @offer = Job::Offer.find(params[:id])
  end
end
