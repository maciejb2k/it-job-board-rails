# frozen_string_literal: true

class Api::V1::Employer::Job::OffersController < ApplicationController
  before_action :set_offer, except: %i[index create]

  def index
    eager_load_associations = %i[
      category technology job_skills_required
      job_languages job_contracts job_locations
    ]

    @pagy, @offers = pagy(
      apply_scopes(Job::Offer.includes(eager_load_associations)) # for n+1 problem
        .order(ordering_params(params)) # order by 'sort' param
        .distinct # avoid redundant records from joins
        .all
    )

    render json: @offers,
           each_serializer: Api::V1::Job::SimpleOfferSerializer
  end

  def show
    render json: Api::V1::Employer::OfferSerializer.new(@offer).to_h
  end

  def create
    @offer = Job::Offer.new(offer_params)
    if @offer.save
      render json: Api::V1::Employer::Job::OfferSerializer.new(@offer).to_h, status: :created
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
    if @offer.destroy
      render json: @offer
    else
      render json: { errors: @offer.errors.to_s }, status: :unprocessable_entity
    end
  end

  private

  def offer_params
    params.require(:offer)
          .permit(:title,
                  :seniority,
                  :body,
                  :valid_until,
                  :is_active,
                  :remote,
                  :travelling,
                  :ua_supported,
                  :interview_online,
                  :category_id,
                  :technology_id,
                  :employer_id,
                  :data,
                  job_skills_attributes: %i[
                    id
                    name
                    level
                    optional
                  ],
                  job_benefits_attributes: %i[
                    id
                    group
                    name
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
                  ],
                  job_locations_attributes: %i[
                    id
                    city
                    street
                    building_number
                    zip_code
                    country
                    country_code
                  ],
                  job_companies_attributes: %i[
                    name
                    logo
                    size
                    data
                  ],
                  job_contacts_attributes: %i[
                    id
                    first_name
                    last_name
                    email
                    phone
                  ],
                  job_languages_attributes: %i[
                    id
                    name
                    code
                    proficiency
                    required
                  ],
                  job_equipment_attributes: %i[
                    id
                    computer
                    monitor
                    linux
                    mac_os
                    windows
                  ])
  end

  def set_offer
    @offer = Job::Offer.find(params[:id])
  end
end
