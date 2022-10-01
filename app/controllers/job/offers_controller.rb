# frozen_string_literal: true

module Job
  class OffersController < ApplicationController
    before_action :set_offer, except: %i[index create]

    def index
      render json: { data: ActiveModel::SerializableResource.new(Offer.all,
                                                                 each_serializer: OfferSerializer) }
    end

    def show
      render json: OfferSerializer.new(@offer).to_h
    end

    def create
      @offer = Offer.new(offer_params)
      if @offer.save
        render json: OfferSerializer.new(@offer).to_h, status: :created
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
                    :interview_online,
                    :category_id,
                    :technology_id,
                    :user_id,
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
                    ])
    end

    def set_offer
      @offer = Offer.find(params[:id])
    end
  end
end
