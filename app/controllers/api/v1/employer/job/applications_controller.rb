# frozen_string_literal: true

class Api::V1::Employer::Job::ApplicationsController < ApplicationController
  include Orderable

  before_action :authenticate_api_v1_employer!
  before_action :set_application, only: %i[show update_status]
  after_action { pagy_headers_merge(@pagy) if @pagy }

  def index
    eager_load_associations = [{ job_offer: :employer }, :job_application_statuses]

    @pagy, @applications = pagy(
      apply_scopes(
        Job::Application
        .includes(eager_load_associations)
        .where(employer: { id: current_api_v1_employer })
      )
      .order(ordering_params(params))
      .all
    )

    render json: @applications, each_serializer: Api::V1::Employer::Job::SimpleApplicationSerializer
  end

  def show
    render json: @application, serializer: Api::V1::Employer::Job::CompleteApplicationSerializer
  end

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
    @application = Job::Application.includes({ job_offer: :employer }, :job_application_statuses)
                                   .find_by!(
                                     employer: { id: current_api_v1_employer },
                                     id: params[:id]
                                   )
  end
end
