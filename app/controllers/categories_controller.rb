# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :set_category, except: %i[index create]

  def index
    render json: {
      data: ActiveModel::SerializableResource.new(
        Category.all,
        each_serializer: CategorySerialize
      )
    }
  end

  def show
    render json: CategorySerializer.new(@category).to_h
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      render json: CategorySerializer.new(@category).to_h, status: :created
    else
      render json: { errors: @category.errors.messages }, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      render json: @category
    else
      render json: { errors: @category.errors.messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.destroy
      render json: @category
    else
      render json: { errors: @category.errors.to_s }, status: :unprocessable_entity
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find(params[:id])
  end
end
