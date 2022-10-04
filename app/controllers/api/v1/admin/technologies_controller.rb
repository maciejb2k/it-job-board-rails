# frozen_string_literal: true

class Api::V1::Admin::TechnologiesController < ApplicationController
  before_action :set_technology, except: %i[index create]

  def index
    render json: {
      data: ActiveModel::SerializableResource.new(
        Technology.all,
        each_serializer: Api::V1::Admin::TechnologySerialize
      )
    }
  end

  def show
    render json: Api::V1::Admin::TechnologySerializer.new(@technology).to_h
  end

  def create
    @technology = Technology.new(technology_params)
    if @technology.save
      render json: Api::V1::TechnologySerializer.new(@technology).to_h, status: :created
    else
      render json: { errors: @technology.errors.messages }, status: :unprocessable_entity
    end
  end

  def update
    if @technology.update(technology_params)
      render json: @technology
    else
      render json: { errors: @technology.errors.messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @technology.destroy
      render json: @technology
    else
      render json: { errors: @technology.errors.to_s }, status: :unprocessable_entity
    end
  end

  private

  def technology_params
    params.require(:technology).permit(:name)
  end

  def set_technology
    @technology = Technology.find(params[:id])
  end
end
