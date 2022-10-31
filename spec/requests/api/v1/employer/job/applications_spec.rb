# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Employer::Job::Applications', type: :request do
  let_it_be(:employer) { create(:employer) }
  let(:login_employer) do
    post api_v1_employer_session_path, params: {
      email: employer.email,
      password: employer.password
    }
  end
  let(:auth_headers) { employer.create_new_auth_token }

  let_it_be(:job_offer) { create(:job_offer, employer:) }

  describe 'GET #index' do
    let_it_be(:job_application) do
      create(:job_application, job_offer:, email: 'maciek@example.com')
    end

    let_it_be(:other_employer) { create(:employer) }
    let_it_be(:other_job_offer) { create(:job_offer, employer: other_employer) }
    let_it_be(:other_job_application) { create(:job_application, job_offer: other_job_offer) }

    it 'blocks access for unauthorized user' do
      get api_v1_employer_job_applications_path
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns job offers associated with employer' do
      get api_v1_employer_job_applications_path, headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
      expect(JSON.parse(response.body)[0]['id']).to eq(job_application.id)
    end

    it 'includes pagy headers' do
      get api_v1_employer_job_applications_path, headers: auth_headers

      expect(response.headers['Current-Page']).not_to be_empty
      expect(response.headers['Total-Pages']).not_to be_empty
      expect(response.headers['Page-Items']).not_to be_empty
    end

    context 'with ordering' do
      before do
        create(:job_application, job_offer:, email: 'jerzy@gmail.com')
        create(:job_application, job_offer:, email: 'andrzej@example.com')
        create(:job_application, job_offer:, email: 'tomek@yahoo.com')
        create(:job_application, job_offer:, email: 'kasztan@pies.pl')
      end

      it 'returns job applications sorted by title descending' do
        get api_v1_employer_job_applications_path, params: { sort: '-email' }, headers: auth_headers

        expected_order = [
          'tomek@yahoo.com',
          'maciek@example.com',
          'kasztan@pies.pl',
          'jerzy@gmail.com',
          'andrzej@example.com'
        ]
        response_order = JSON.parse(response.body).map { |application| application['email'] }

        expect(response_order).to match_array(expected_order)
      end
    end
  end

  describe 'GET #show' do
    let_it_be(:job_application) { create(:job_application, job_offer:) }

    it 'blocks access for unauthorized user' do
      get api_v1_employer_job_application_path(id: job_application.id)
      expect(response).to have_http_status(:unauthorized)
    end

    context 'when job offer exists' do
      it 'returns single job application' do
        get api_v1_employer_job_application_path(id: job_application.id), headers: auth_headers

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['id']).to eq(job_application.id)
        expect(JSON.parse(response.body)['job_offer_id']).to eq(job_offer.id)
      end
    end

    context "when job offer doesn't exist" do
      it 'responds with http record not found', :realistic_error_responses do
        get api_v1_employer_job_application_path(id: 1), headers: auth_headers
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #update_status' do
    let_it_be(:job_application) { create(:job_application, job_offer:) }

    context 'when application is not closed' do
      it 'updates status' do
        post update_status_api_v1_employer_job_application_path(id: job_application.id), params: {
          application: {
            status: 'in_progress',
            note: '...'
          }
        }, headers: auth_headers

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['status']).to eq('in_progress')
      end

      it 'closes application' do
        create(:job_application_status, job_application:, status: 'in_progress')

        post update_status_api_v1_employer_job_application_path(id: job_application.id), params: {
          application: {
            status: 'hired',
            note: '...'
          }
        }, headers: auth_headers

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['status']).to eq('hired')
      end
    end

    context 'when application is closed' do
      it 'prevents setting new status' do
        create(:job_application_status, job_application:, status: 'hired')

        post update_status_api_v1_employer_job_application_path(id: job_application.id), params: {
          application: {
            status: 'in_progress',
            note: '...'
          }
        }, headers: auth_headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']['status'][0]).to(
          eq('cannot update status, if application is closed')
        )
      end
    end

    it 'prevents setting the same status twice' do
      create(:job_application_status, job_application:, status: 'in_progress')

      post update_status_api_v1_employer_job_application_path(id: job_application.id), params: {
        application: {
          status: 'in_progress',
          note: '...'
        }
      }, headers: auth_headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']['status'][0]).to(
        eq('cannot set the same status twice')
      )
    end
  end
end
