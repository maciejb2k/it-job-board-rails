# frozen_string_literal: true

class Api::V1::Candidate::DetailsController < ApplicationController
  before_action :authenticate_api_v1_candidate!
  before_action :set_detail, except: %i[create]
  before_action :check_detail_exists, only: %i[create]

  def show
    render json: @detail, serializer: Api::V1::Candidate::DetailSerializer
  end

  def create
    @detail = current_api_v1_candidate.build_candidate_detail(detail_params)

    if @detail.save
      render json: @detail, status: :created
    else
      render json: @detail.errors, status: :unprocessable_entity
    end
  end

  def update
    if @detail.update(detail_params)
      render json: @detail
    else
      render json: @detail.errors, status: :unprocessable_entity
    end
  end

  def destroy
    render json: @detail if @detail.destroy
  end

  private

  def check_detail_exists
    return unless current_api_v1_candidate.candidate_detail

    render json: { error: 'user detail already exists' }, status: :unprocessable_entity
  end

  def set_detail
    # TODO: is this a good practise?
    @detail = current_api_v1_candidate.candidate_detail
    raise ActiveRecord::RecordNotFound unless @detail
  end

  def detail_params
    params.require(:detail).permit(
      :photo,
      :location,
      :seniority,
      :status,
      :specialization,
      :position,
      :salary_from,
      :salary_to,
      :hide_salary,
      :industry,
      :carrer_path,
      :technology
    )
  end
end
