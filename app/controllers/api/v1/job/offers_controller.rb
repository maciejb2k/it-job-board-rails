# frozen_string_literal: true

class Api::V1::Job::OffersController < ApplicationController
  include Orderable

  before_action :set_offer, except: %i[index]
  after_action { pagy_headers_merge(@pagy) if @pagy }

  with_options only: :index do
    has_scope :is_active, default: nil, allow_blank: true
    has_scope :is_interview_online, type: :boolean, allow_blank: true
    has_scope :is_ua_supported, type: :boolean, allow_blank: true
    has_scope :by_title
    has_scope :by_category, type: :array
    has_scope :by_technology, type: :array
    has_scope :by_remote
    has_scope :by_travelling
    has_scope :by_city, type: :array
    has_scope :by_seniority
    has_scope :by_currency, type: :array
    has_scope :by_employment, type: :array
    has_scope :by_language, type: :array
    has_scope :by_skill, type: :array
    has_scope :by_salary, using: %i[from to]
  end

  def index
    eager_load_associations = %i[
      category technology job_skills_required
      job_languages job_contracts job_locations
    ]

    @pagy, @offers = pagy(
      apply_scopes(Job::Offer)
        .order(ordering_params(params))
        .includes(eager_load_associations)
        .distinct
        .all
    )

    render json: @offers,
           each_serializer: Api::V1::Job::SimpleOfferSerializer
  end

  def show
    render json: @offer, serializer: Api::V1::Job::CompleteOfferSerializer
  end

  def apply
    @application = @offer.job_applications.build(application_params)

    if @application.save
      render json: @application, status: :created
    else
      render json: { errors: @application.errors.messages }
    end
  end

  private

  def application_params
    params.require(:application).permit(
      :first_name,
      :last_name,
      :email,
      :phone,
      :cv,
      :data,
      :note,
      :work_from,
      :city,
      :contract,
      :start_time,
      :working_hours,
      :status
    )
  end

  def set_offer
    @offer = Job::Offer.find(params[:id])
  end
end
