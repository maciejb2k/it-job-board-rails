# frozen_string_literal: true

class Api::V1::Job::ApplicationsController < ApplicationController
  def create
    @application = Job::Application.new(application_params)
    if @application.save
      render json: @application, status: :created
    else
      render json: { errors: @application.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def application_params
    params.require(:application).permit()
  end
end
