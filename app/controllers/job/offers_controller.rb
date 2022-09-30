# frozen_string_literal: true

module Job
  class OffersController < ApplicationController
    before_action :set_offer, except: %i[create]

    def create
      @form = OfferForm.new(offer_params)
      if @form.save
        render json: OfferSerializer.new(@form.offer).to_h, status: :ok
      else
        render json: { errors: @form.errors.messages }, status: :unprocessable_entity
      end
    end

    private

    def offer_params
      params.require(:offer)
            .permit(offers_attributes: %i[
                      title
                      seniority
                      body
                      valid_until
                      is_active
                      remote
                      interview_online
                      category_id
                      technology_id
                      user_id
                    ],
                    skills_attributes: %i[
                      name
                      level
                      optional
                    ],
                    benefits_attributes: %i[
                      group
                      name
                    ],
                    contracts_attributes: %i[
                      employment
                      hide_salary
                      from
                      to
                      currency
                    ],
                    locations_attributes: %i[
                      city
                      street
                      building_number
                      zip_code
                      country
                      country_code
                    ],
                    company_attributes: %i[
                      name
                      logo
                      size
                      data
                    ],
                    contacts_attributes: %i[
                      first_name
                      last_name
                      email
                      phone
                    ],
                    languages_attributes: %i[
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
