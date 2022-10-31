# frozen_string_literal: true

class Api::V1::Candidate::Job::ApplicationsController < ApplicationController
  include Orderable

  before_action :authenticate_api_v1_candidate!
  before_action :set_application, only: %i[show resign]
  after_action { pagy_headers_merge(@pagy) if @pagy }

  def index
    eager_load_associations = %i[job_offer job_application_statuses]

    @pagy, @applications = pagy(
      apply_scopes(current_api_v1_candidate.job_applications)
      .includes(eager_load_associations)
      .order(ordering_params(params, 'Job::Application'))
      .all
    )

    render json: @applications,
           each_serializer: Api::V1::Candidate::Job::SimpleApplicationSerializer
  end

  def show
    render json: @application, serializer: Api::V1::Candidate::Job::CompleteApplicationSerializer
  end

  def resign
    @application_status = @application.job_application_statuses.build(application_params)

    if @application_status.save
      render json: @application_status, status: :created
    else
      render json: { errors: @application_status.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def set_application
    # TODO: refactor to current_api_v1_candidate.job_applications
    @application = Job::Application.find_by!(id: params[:id], candidate: current_api_v1_candidate)
  end

  def application_params
    # TODO: untested .allow method from gem 'allowable'
    params.require(:application).permit(:status, :note).allow(status: 'resigned')
  end
end
