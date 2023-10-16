# frozen_string_literal: true

class Api::V1::Job::OffersController < ApplicationController
  include Orderable

  before_action :set_offer, except: %i[index]
  before_action :check_user_exists, only: %i[apply]

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
    # names from model
    eager_load_associations = %i[
      category technology job_skills_required
      job_languages job_contracts job_locations
    ]

    @pagy, @offers = pagy(
      apply_scopes(Job::Offer)
        .order(ordering_params(params, 'Job::Offer')) # order by 'sort' param
        .includes(eager_load_associations) # for n+1 problem
        .distinct # avoid redundant records from joins
        .all
    )

    render json: @offers,
           each_serializer: Api::V1::Job::SimpleOfferSerializer
  end

  def show
    render json: @offer, serializer: Api::V1::Job::CompleteOfferSerializer
  end

  def apply
    @application = @offer.job_applications.build(
      apply_params.merge(
        candidate: current_api_v1_candidate
      )
    )

    if api_v1_candidate_signed_in?
      @application.email = current_api_v1_candidate.email
      @application.first_name = current_api_v1_candidate.first_name
      @application.last_name = current_api_v1_candidate.last_name
    end

    if @application.save
      render json: @application, status: :created
    else
      render json: { errors: @application.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def apply_params
    params.require(:apply).permit(
      :first_name,
      :last_name,
      :email,
      :phone,
      :cv,
      :data,
      :note,
      :work_form,
      :city,
      :contract,
      :start_time,
      :working_hours
    )
  end

  def set_offer
    @offer = Job::Offer.find(params[:id])
  end

  # TODO: untested feature, probably error prone
  def check_user_exists
    return if api_v1_candidate_signed_in?
    return unless params[:apply] && Candidate.exists?(email: params[:apply][:email])

    render json: {
      error: 'applying from registered e-mail requires signing in first'
    }, status: :unprocessable_entity
  end
end
