# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Candidate::Job::Applications', type: :request do
  let_it_be(:candidate) { create(:candidate) }
  let(:login_candidate) do
    post api_v1_candidate_session_path, params: {
      email: candidate.email,
      password: candidate.password
    }
  end
  let(:auth_headers) { candidate.create_new_auth_token }

  describe 'GET #index' do
    context 'when candidate is not signed in' do
      it 'responds with unauthorized' do
        get api_v1_candidate_job_applications_path
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when candidate is signed in' do
      let_it_be(:job_application) { create(:job_application, candidate:, first_name: 'Maciej') }
      let_it_be(:other_application) { create(:job_application) } # should not be included

      it 'returns applications associated with candidate' do
        get api_v1_candidate_job_applications_path, headers: auth_headers

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(1)
        expect(JSON.parse(response.body)[0]['id']).to eq(job_application.id)
      end

      it 'includes pagy headers' do
        get api_v1_candidate_job_applications_path, headers: auth_headers

        expect(response.headers['Current-Page']).not_to be_empty
        expect(response.headers['Total-Pages']).not_to be_empty
        expect(response.headers['Page-Items']).not_to be_empty
      end

      # Ale gówniany test XDDDDDD Refactor trzeba koniecznie.
      context 'with ordering' do
        let_it_be(:first_application) do
          create(:job_application, candidate:, created_at: Time.zone.now + 10)
        end
        let_it_be(:second_application) do
          create(:job_application, candidate:, created_at: Time.zone.now + 20)
        end
        let_it_be(:third_application) do
          create(:job_application, candidate:, created_at: Time.zone.now + 30)
        end

        it 'returns job applications sorted by creation date descending' do
          get(
            api_v1_candidate_job_applications_path,
            params: { sort: '-created_at' },
            headers: auth_headers
          )

          expected_order = [
            third_application.created_at.utc.to_s,
            second_application.created_at.utc.to_s,
            first_application.created_at.utc.to_s,
            job_application.created_at.utc.to_s
          ]
          response_order = JSON.parse(response.body).map do |application|
            Time.zone.parse(application['created_at']).utc.to_s
          end

          expect(response_order).to match_array(expected_order)
        end
      end
    end
  end

  describe 'GET #show' do
    context 'when candidate is not signed in' do
      it 'responds with unauthorized' do
        get api_v1_candidate_job_application_path(id: 1)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when candidate is signed in' do
      let_it_be(:application) { create(:job_application, candidate:) }

      context 'when record does exists' do
        it 'returns application' do
          get api_v1_candidate_job_application_path(id: application.id), headers: auth_headers

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['id']).to eq(application.id)
        end
      end

      context "when record doesn't exists" do
        it 'responds with http 404', :realistic_error_responses do
          get api_v1_candidate_job_application_path(id: 1), headers: auth_headers
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'POST #resign' do
    context 'when candidate is not signed in' do
      it 'responds with unauthorized' do
        post resign_api_v1_candidate_job_application_path(id: 1)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when candidate is signed in' do
      context 'when application is opened' do
        let_it_be(:application) { create(:job_application, candidate:) }

        context 'when params missing' do
          it 'responds with bad_request', :realistic_error_responses do
            post(
              resign_api_v1_candidate_job_application_path(id: application.id),
              headers: auth_headers
            )

            expect(response).to have_http_status(:bad_request)
          end
        end

        context 'when invalid params' do
          it 'responds with unprocessable_entity' do
            post(
              resign_api_v1_candidate_job_application_path(id: application.id),
              params: {
                application: {
                  note: nil
                }
              },
              headers: auth_headers
            )

            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        context "when provided status is 'resigned'" do
          it 'updates application status' do
            post(
              resign_api_v1_candidate_job_application_path(id: application.id),
              params: {
                application: {
                  status: 'resigned',
                  note: ''
                }
              },
              headers: auth_headers
            )

            expect(response).to have_http_status(:created)
          end
        end

        context "when provided status is different than 'resigned'" do
          it 'responses with unprocessable_entity' do
            post(
              resign_api_v1_candidate_job_application_path(id: application.id),
              params: {
                application: {
                  status: 'hired',
                  note: ''
                }
              },
              headers: auth_headers
            )

            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end

      context 'when application is closed' do
        let_it_be(:job_application) { create(:job_application, candidate:) }
        let_it_be(:closed_status) do
          create(:job_application_status, job_application:, status: 'resigned')
        end

        it 'responses with error' do
          post(
            resign_api_v1_candidate_job_application_path(id: job_application.id),
            params: {
              application: {
                status: 'resigned',
                note: ''
              }
            },
            headers: auth_headers
          )

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
