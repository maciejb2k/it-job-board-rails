# frozen_string_literal: true

class Api::V1::Job::OffersController < ApplicationController
  include Orderable
  include ActionController::Caching

  before_action :set_offer, except: %i[index]
  before_action :check_user_exists, only: %i[apply]
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
    # Eager load required associations
    eager_load_associations = %i[
      category technology job_skills_required
      job_languages job_contracts job_locations
    ]

    # Create results set
    @pagy, @offers = pagy(
      apply_scopes(Job::Offer)
        .order(ordering_params(params, 'Job::Offer')) # order by 'sort' param
        .includes(eager_load_associations) # for n+1 problem
        .distinct # avoid redundant records from joins
        .all
    )

    # Prevent caching empty result set
    if @offers.empty?
      result = []
    else
      # Look for changes in table
      # Might be error prone, but if results are not empty, it will execute
      last_modified = Job::Offer.order(:updated_at).last
      # Create unique cache key for data and params set
      cache_key = create_cache_key(last_modified, @pagy, params, current_scopes)

      # Serialized objects are stored in cache
      result = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
        serializer = ActiveModel::Serializer::CollectionSerializer.new(
          @offers,
          serializer: Api::V1::Job::SimpleOfferSerializer
        )
        serializer.to_json
      end
    end

    render json: result
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

  def create_cache_key(last_modified, pagy, params, current_scopes)
    cache_hash = "
    #{last_modified.updated_at}
    #{pagy.page}
    #{pagy.items}
    #{params[:sort]}
    #{current_scopes}".hash
    "api/v1/job/offers/#{cache_hash}"
  end

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
