# frozen_string_literal: true

class Api::V1::Employer::Job::ApplicationsController < ApplicationController
  before_action :set_application

  def update_status
    @application_status = @application.job_application_statuses.build(application_params)
    if @application_status.save
      render json: @application_status, status: :created
    else
      render json: { errors: @application_status.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def application_params
    params.require(:application).permit(
      :status,
      :note
    )
  end

  def set_application
    @application = Job::Application.find(params[:id])
  end
end
