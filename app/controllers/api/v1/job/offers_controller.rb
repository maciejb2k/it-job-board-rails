# frozen_string_literal: true

class Api::V1::Job::OffersController < ApplicationController
  before_action :set_offer, except: %i[index]

  has_scope :active, default: nil, allow_blank: true, only: :index
  has_scope :by_category, only: :index
  has_scope :by_technology, only: :index

  def index
    @offers = apply_scopes(Job::Offer).all
    render json: @offers, each_serializer: Api::V1::Job::SimpleOfferSerializer
  end

  def show
    render json: @offer, serializer: Api::V1::Job::CompleteOfferSerializer
  end

  private

  def set_offer
    @offer = Job::Offer.find(params[:id])
  end
end
