# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Candidate::Details', type: :request do
  let_it_be(:candidate) { create(:candidate) }
  let(:login_candidate) do
    post api_v1_candidate_session_path, params: {
      email: candidate.email,
      password: candidate.password
    }
  end
  let(:auth_headers) { candidate.create_new_auth_token }

  describe 'GET #show' do
    context 'when candidate is not signed in' do
      it 'responds with unauthorized' do
        get api_v1_candidate_detail_path(id: 1)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when candidate is signed in' do
      context 'when record exists' do
        let_it_be(:candidate_detail) { create(:candidate_detail, candidate:) }

        it 'returns candidate details' do
          get api_v1_candidate_detail_path(id: candidate_detail.id), headers: auth_headers

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['id']).to eq(candidate_detail.id)
        end
      end

      context "when record doesn't exist" do
        it 'responds with http 404', :realistic_error_responses do
          get api_v1_candidate_detail_path(id: 1), headers: auth_headers
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'POST #create' do
    context 'when candidate is not signed in' do
      it 'responds with unauthorized' do
        post api_v1_candidate_detail_path
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when candidate is signed in' do
      let_it_be(:valid_params) do
        {
          detail: {
            photo: 'link',
            location: 'Rzeszow',
            seniority: 5,
            status: 'learning',
            specialization: 'backend',
            position: 'manager',
            salary_from: 20_000,
            salary_to: 35_000,
            hide_salary: false,
            industry: 'fintech',
            carrer_path: '...',
            technology: 'Rails'
          }
        }
      end

      context 'with missing params' do
        it 'raises ActionController::ParameterMissing' do
          expect { post api_v1_candidate_detail_path, headers: auth_headers }.to(
            raise_error(ActionController::ParameterMissing)
          )
        end

        it 'responds with http 400', :realistic_error_responses do
          post api_v1_candidate_detail_path, headers: auth_headers
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with invalid params' do
        it 'responds with http 422', :realistic_error_responses do
          post(
            api_v1_candidate_detail_path,
            params: {
              detail: {
                salary_from: 5000,
                salary_to: 2000
              }
            },
            headers: auth_headers
          )

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'with valid params' do
        it 'successfuly creates candidate details' do
          post(
            api_v1_candidate_detail_path,
            params: valid_params,
            headers: auth_headers
          )

          expect(response).to have_http_status(:created)
        end
      end

      context 'when user details alerady exists' do
        let_it_be(:existing_details) { create(:candidate_detail, candidate:) }

        it 'responds with http 422 and custom message', :realistic_error_responses do
          post(
            api_v1_candidate_detail_path,
            params: valid_params,
            headers: auth_headers
          )

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['error']).to eq('user detail already exists')
        end
      end
    end
  end

  describe 'UPDATE #update' do
    context 'when candidate is not signed in' do
      it 'responds with unauthorized' do
        put api_v1_candidate_detail_path(id: 1)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when candidate is signed in' do
      context 'when details exists' do
        let_it_be(:candidate_detail) { create(:candidate_detail, candidate:) }

        context 'with invalid params' do
          it 'responds with unprocessable entity' do
            put(
              api_v1_candidate_detail_path(id: candidate_detail.id),
              params: {
                detail: {
                  seniority: 7
                }
              },
              headers: auth_headers
            )

            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        it 'updates details' do
          put(
            api_v1_candidate_detail_path(id: candidate_detail.id),
            params: {
              detail: {
                seniority: 1,
                industry: 'blockchain'
              }
            },
            headers: auth_headers
          )

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['seniority']).to eq('1')
          expect(JSON.parse(response.body)['industry']).to eq('blockchain')
        end
      end

      context "when record doesn't exist" do
        it 'responds with http 404', :realistic_error_responses do
          put api_v1_candidate_detail_path(id: 1), headers: auth_headers
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when candidate is not signed in' do
      it 'responds with unauthorized' do
        delete api_v1_candidate_detail_path(id: 1)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when candidate is signed in' do
      context 'when details does exists' do
        let_it_be(:candidate_detail) { create(:candidate_detail, candidate:) }

        it 'responds with http 200' do
          delete api_v1_candidate_detail_path(id: candidate_detail.id), headers: auth_headers

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['id']).to eq(candidate_detail.id)
          expect { candidate_detail.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "when record doesn't exist" do
        it 'responds with http 404', :realistic_error_responses do
          delete api_v1_candidate_detail_path(id: 1), headers: auth_headers
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
