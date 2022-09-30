require 'rails_helper'

RSpec.describe "Job::OfferForms", type: :request do
  describe "GET /job/offer_forms" do
    it "works! (now write some real specs)" do
      get job_offer_forms_path
      expect(response).to have_http_status(200)
    end
  end
end
