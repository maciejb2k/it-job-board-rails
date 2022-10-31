# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Employer::Job::Offers', type: :request do
  let_it_be(:employer) { create(:employer) }
  let(:login_employer) do
    post api_v1_employer_session_path, params: {
      email: employer.email,
      password: employer.password
    }
  end
  let(:auth_headers) { employer.create_new_auth_token }

  describe 'GET #index' do
    context 'when employer is unauthorized' do
      it 'responds with unauthorized' do
        get api_v1_employer_job_offers_path
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when employer is authorized' do
      it 'returns records belonging to employer' do
        create(:job_offer) # extra job offer not belonging to employer
        job_offer = create(:job_offer, employer:)

        get api_v1_employer_job_offers_path, headers: auth_headers

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(1)
        expect(JSON.parse(response.body)[0]['id']).to eq(job_offer.id)
      end

      it 'includes pagy headers' do
        get api_v1_employer_job_offers_path, headers: auth_headers

        expect(response.headers['Current-Page']).not_to be_empty
        expect(response.headers['Total-Pages']).not_to be_empty
        expect(response.headers['Page-Items']).not_to be_empty
      end

      context 'with ordering' do
        before do
          create(:job_offer, employer:, title: 'Senior Rails Developer', seniority: 5)
          create(:job_offer, employer:, title: 'Junior Rails Developer', seniority: 2)
          create(:job_offer, employer:, title: 'Engineering Manager', seniority: 3)
          create(:job_offer, employer:, title: 'Intern React Developer', seniority: 1)
        end

        it 'returns job offers sorted by title ascending' do
          get api_v1_employer_job_offers_path, params: { sort: 'title' }, headers: auth_headers

          expected_order = [
            'Engineering Manager',
            'Intern React Developer',
            'Junior Rails Developer',
            'Senior Rails Developer'
          ]
          response_order = JSON.parse(response.body).map { |offer| offer['title'] }

          expect(response_order).to match_array(expected_order)
        end

        it 'returns job offers sorted by title descending' do
          get api_v1_employer_job_offers_path, params: { sort: '-title' }, headers: auth_headers

          expected_order = [
            'Senior Rails Developer',
            'Junior Rails Developer',
            'Intern React Developer',
            'Engineering Manager'
          ]
          response_order = JSON.parse(response.body).map { |offer| offer['title'] }

          expect(response_order).to match_array(expected_order)
        end
      end
    end
  end

  describe 'GET #show' do
    context 'when employer is unauthorized' do
      it 'responds with http 401' do
        get api_v1_employer_job_offer_path(id: 1)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when employer is authorized' do
      context 'when job offer exists' do
        let_it_be(:job_offer) { create(:job_offer, employer:) }

        it 'returns single job application' do
          get api_v1_employer_job_offer_path(id: job_offer.id), headers: auth_headers

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['id']).to eq(job_offer.id)
        end
      end

      context "when job offer doesn't exist" do
        it 'responds with http 404', :realistic_error_responses do
          get api_v1_employer_job_offer_path(id: 1), headers: auth_headers
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'POST #create' do
    context 'when employer is unauthorized' do
      it 'responds with http 401' do
        post api_v1_employer_job_offers_path
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when employer is authorized' do
      context 'with missing params' do
        it 'raises ActionController::ParameterMissing' do
          expect { post api_v1_employer_job_offers_path, headers: auth_headers }.to(
            raise_error(ActionController::ParameterMissing)
          )
        end

        it 'responds with http 400', :realistic_error_responses do
          post api_v1_employer_job_offers_path, headers: auth_headers
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with invalid params' do
        it 'responds with http 422', :realistic_error_responses do
          post(
            api_v1_employer_job_offers_path,
            params: {
              offer: { title: '' }
            },
            headers: auth_headers
          )

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'with valid params' do
        it 'successfuly creates job offer' do
          category = create(:category, name: 'backend')
          technology = create(:technology, name: 'ruby')

          post(
            api_v1_employer_job_offers_path,
            params: {
              offer: {
                title: 'Ruby on Rails Developer',
                seniority: 3,
                body: '...',
                valid_until: Time.zone.now + 86_400,
                remote: 5,
                travelling: 'none',
                ua_supported: true,
                interview_online: true,
                category_id: category.id,
                technology_id: technology.id,
                data: '{"links": []}',
                job_skills_attributes: [
                  {
                    name: 'ruby',
                    level: 3
                  },
                  {
                    name: 'ruby on rails',
                    level: 4
                  },
                  {
                    name: 'aws',
                    level: 1,
                    optional: true
                  }
                ],
                job_benefits_attributes: [
                  {
                    group: 'health',
                    name: 'health care package'
                  },
                  {
                    group: 'office',
                    name: 'free parking spot'
                  },
                  {
                    group: 'office',
                    name: 'free food'
                  }
                ],
                job_contracts_attributes: [
                  {
                    employment: 'uop',
                    hide_salary: false,
                    from: 5000,
                    to: 8000,
                    currency: 'pln',
                    payment_period: 'monthly',
                    paid_vacation: true
                  },
                  {
                    employment: 'b2b',
                    hide_salary: false,
                    from: 10_000,
                    to: 13_000,
                    currency: 'pln',
                    payment_period: 'monthly',
                    paid_vacation: true
                  }
                ],
                job_locations_attributes: [
                  {
                    city: 'Rzeszów',
                    street: 'ul. Kolejowa',
                    building_number: '2',
                    zip_code: '35-123',
                    country: 'Poland',
                    country_code: 'PL'
                  },
                  {
                    city: 'Warszawa',
                    street: 'ul. Słoneczna',
                    building_number: '678',
                    zip_code: '65-788',
                    country: 'Poland',
                    country_code: 'PL'
                  },
                  {
                    city: 'Kraków',
                    street: 'ul. Drewniana',
                    building_number: '43/5',
                    zip_code: '12-163',
                    country: 'Poland',
                    country_code: 'PL'
                  }
                ],
                job_company_attributes: {
                  name: 'W Gorącej Wodzie Company',
                  logo: 'https://ecs-aws.com/path/to/file.png',
                  size: 100,
                  data: '{"links": []}'
                },
                job_contacts_attributes: [
                  {
                    first_name: 'Agnieszka',
                    last_name: 'TuNieMieszka',
                    email: 'masnyben@gmail.com',
                    phone: '123456789'
                  },
                  {
                    first_name: 'Tomasz',
                    last_name: 'Kowalski',
                    email: 'topewniejerzy@gmail.com'
                  }
                ],
                job_languages_attributes: [
                  {
                    name: 'English',
                    code: 'en',
                    proficiency: 'b2'
                  },
                  {
                    name: 'Polish',
                    code: 'pl'
                  }
                ],
                job_equipment_attributes: {
                  computer: 'notebook',
                  monitor: 1
                }
              }
            },
            headers: auth_headers
          )

          expect(response).to have_http_status(:created)
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'when employer is unauthorized' do
      it 'responds with http 401' do
        put api_v1_employer_job_offer_path(id: 1)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when employer is authorized' do
      context 'when job offer exists' do
        it 'updates job application' do
          job_offer = create(:job_offer, employer:, title: 'to change')
          new_title = 'Senior NodeJS Developer'

          put(
            api_v1_employer_job_offer_path(id: job_offer.id),
            params: { offer: { title: new_title } },
            headers: auth_headers
          )

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['title']).to eq(new_title)
        end
      end

      it 'updates nested attributes', :realistic_error_responses do
        new_name = 'Google Cloud Platform'
        old_name = 'Azure'

        job_offer = create(:job_offer, employer:)
        skill = create(:job_skill, job_offer:, name: old_name)

        put(
          api_v1_employer_job_offer_path(id: job_offer.id),
          params: {
            offer: {
              job_skills_attributes: [
                {
                  id: skill.id,
                  name: new_name
                }
              ]
            }
          },
          headers: auth_headers
        )

        # I teraz czy sobie strzelić skill.reload i sprawdzic change { skill.name }.to(new_name),
        # czy przeszukać response i zobaczyć, czy zawiera ona new_name.

        expect(response).to have_http_status(:ok)
        expect { skill.reload }.to change { skill.name }.from(old_name).to(new_name)
      end

      it 'deletes nested attributes' do
        job_offer = create(:job_offer, employer:)
        skill = create(:job_skill, job_offer:)

        put(
          api_v1_employer_job_offer_path(id: job_offer.id),
          params: {
            offer: {
              job_skills_attributes: [
                {
                  id: skill.id,
                  _destroy: true
                }
              ]
            }
          },
          headers: auth_headers
        )

        expect(response).to have_http_status(:ok)
        expect { skill.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      context 'when all required in model associated records are deleted' do
        it 'responds with validation error and http 422', :realistic_error_responses do
          job_offer = create(:job_offer, employer:)

          put(
            api_v1_employer_job_offer_path(id: job_offer.id),
            params: {
              offer: {
                job_skills_attributes: [
                  {
                    # job skill is created in factory: spec/factories/job/offers.rb
                    id: job_offer.job_skills.first.id,
                    _destroy: true
                  }
                ]
              }
            },
            headers: auth_headers
          )

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context "when job offer doesn't exist" do
        it 'responds with http 404', :realistic_error_responses do
          get api_v1_employer_job_offer_path(id: 1), headers: auth_headers
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when employer is unauthorized' do
      it 'responds with http 401' do
        delete api_v1_employer_job_offer_path(id: 1)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when employer is authorized' do
      context 'when job offer does exists' do
        it 'responds with http 200' do
          job_offer = create(:job_offer, employer:)

          delete api_v1_employer_job_offer_path(id: job_offer.id), headers: auth_headers

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['id']).to eq(job_offer.id)
          expect { job_offer.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "when job offer doesn't exists" do
        it 'responds with http 404', :realistic_error_responses do
          delete api_v1_employer_job_offer_path(id: 1), headers: auth_headers
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
