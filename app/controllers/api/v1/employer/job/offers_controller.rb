# frozen_string_literal: true

class Api::V1::Employer::Job::OffersController < ApplicationController
  include Orderable

  before_action :authenticate_api_v1_employer!
  before_action :set_offer, except: %i[index create]
  after_action { pagy_headers_merge(@pagy) if @pagy }

  def index
    eager_load_associations = %i[
      category technology job_skills_required
      job_languages job_contracts job_locations
    ]

    @pagy, @offers = pagy(
      apply_scopes(
        current_api_v1_employer.job_offers.includes(eager_load_associations)
      ) # for n+1 problem
      .order(ordering_params(params, 'Job::Offer')) # order by 'sort' param
      .distinct # avoid redundant records from joins
      .all
    )

    render json: @offers,
           each_serializer: Api::V1::Job::SimpleOfferSerializer
  end

  def show
    render json: @offer, serializer: Api::V1::Employer::Job::OfferSerializer
  end

  def create
    @offer = current_api_v1_employer.job_offers.build(offer_params)

    if @offer.save
      render json: @offer, serializer: Api::V1::Employer::Job::OfferSerializer, status: :created
    else
      render json: { errors: @offer.errors.messages }, status: :unprocessable_entity
    end
  end

  def update
    if @offer.update(offer_params)
      render json: @offer
    else
      render json: { errors: @offer.errors.messages }, status: :unprocessable_entity
    end
  end

  def destroy
    render json: @offer if @offer.destroy
  end

  private

  def offer_params
    params.require(:offer)
          .permit(:title,
                  :seniority,
                  :body,
                  :valid_until,
                  :remote,
                  :travelling,
                  :ua_supported,
                  :interview_online,
                  :category_id,
                  :technology_id,
                  :data,
                  job_skills_attributes: %i[
                    id
                    name
                    level
                    optional
                    _destroy
                  ],
                  job_benefits_attributes: %i[
                    id
                    group
                    name
                    _destroy
                  ],
                  job_contracts_attributes: %i[
                    id
                    employment
                    hide_salary
                    from
                    to
                    currency
                    payment_period
                    paid_vacation
                    _destroy
                  ],
                  job_locations_attributes: %i[
                    id
                    city
                    street
                    building_number
                    zip_code
                    country
                    country_code
                    _destroy
                  ],
                  job_company_attributes: %i[
                    name
                    logo
                    size
                    data
                    _destroy
                  ],
                  job_contacts_attributes: %i[
                    id
                    first_name
                    last_name
                    email
                    phone
                    _destroy
                  ],
                  job_languages_attributes: %i[
                    id
                    name
                    code
                    proficiency
                    required
                    _destroy
                  ],
                  job_equipment_attributes: %i[
                    id
                    computer
                    monitor
                    linux
                    mac_os
                    windows
                    _destroy
                  ])
  end

  def set_offer
    @offer = current_api_v1_employer.job_offers.find(params[:id])
  end
end
