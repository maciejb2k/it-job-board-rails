class Api::V1::TechnologiesController < ApplicationController
  def index
    render json: Technology.all
  end
end