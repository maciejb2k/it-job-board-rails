# frozen_string_literal: true

class Api::V1::Job::OffersController < ApplicationController
  before_action :set_offer, except: %i[index]

  with_options only: :index do
    has_scope :is_active, default: nil, allow_blank: true
    has_scope :by_category
    has_scope :by_technology
    has_scope :by_remote
    has_scope :by_travelling
    has_scope :by_seniority
    has_scope :interview_online, type: :boolean, allow_blank: true
    has_scope :ua_supported, type: :boolean, allow_blank: true
  end

  def index
    eager_load_associations = %i[
      category technology job_skills_required
      job_languages job_contracts job_locations
    ]

    @offers = apply_scopes(
      Job::Offer.includes(eager_load_associations).limit(100)
    ).all

    render json: @offers,
           each_serializer: Api::V1::Job::SimpleOfferSerializer
  end

  private

  def set_offer
    @offer = Job::Offer.find(params[:id])
  end
end
