# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Job::Offers', type: :request do
  describe 'GET #index' do
    it 'returns http success' do
      get api_v1_job_offers_path
      expect(response).to have_http_status(:ok)
    end

    it 'returns job offers' do
      create(:job_offer)
      create(:job_offer)
      get api_v1_job_offers_path

      expect(JSON.parse(response.body).size).to eq(2)
    end

    it 'returns job offer with given title' do
      title = 'blockchain developer'
      create(:job_offer, title:)
      get api_v1_job_offers_path

      expect(JSON.parse(response.body)[0]['title']).to eq(title)
    end

    context 'with .is_active scope' do
      before do
        create(:job_offer, is_active: false)
        create(:job_offer, is_active: true)
        create(:job_offer, valid_until: (Time.zone.now - 1.day), skip_validations: true)
        get api_v1_job_offers_path
      end

      it 'returns only active job offers' do
        expect(JSON.parse(response.body).size).to eq(1)
        expect(JSON.parse(response.body)[0]['is_active']).to eq(true)
      end
    end

    context 'with .is_interview_online scope' do
      before do
        create(:job_offer, interview_online: false)
        create(:job_offer, interview_online: true)

        get api_v1_job_offers_path, params: { is_interview_online: true }
      end

      it 'returns job offers only with interview online' do
        expect(JSON.parse(response.body).size).to eq(1)
        expect(JSON.parse(response.body)[0]['interview_online']).to eq(true)
      end
    end

    context 'with .is_ua_supported scope' do
      before do
        create(:job_offer, ua_supported: false)
        create(:job_offer, ua_supported: true)

        get api_v1_job_offers_path, params: { is_ua_supported: true }
      end

      it 'returns job offers only with interview online' do
        expect(JSON.parse(response.body).size).to eq(1)
        expect(JSON.parse(response.body)[0]['ua_supported']).to eq(true)
      end
    end

    context 'with .by_title scope' do
      let(:title) { 'Senior Ruby on Rails Developer' }
      let(:partial_title) { 'Ruby on Rails' }

      before do
        create(:job_offer, title:)
        create(:job_offer, title: 'UI/UX Intern')
      end

      it 'returns job offers with exactly given title' do
        get api_v1_job_offers_path, params: { by_title: title }

        expect(JSON.parse(response.body).size).to eq(1)
        expect(JSON.parse(response.body)[0]['title']).to eq(title)
      end

      it 'returns job offers with partially given title' do
        get api_v1_job_offers_path, params: { by_title: partial_title }

        expect(JSON.parse(response.body).size).to eq(1)
        expect(JSON.parse(response.body)[0]['title']).to eq(title)
      end
    end

    context 'with .by_category scope' do
      let(:backend_category) { create(:category, name: 'backend') }
      let(:frontend_category) { create(:category, name: 'frontend') }
      let(:qa_category) { create(:category, name: 'qa') }

      before do
        create(:job_offer, category: backend_category)
        create(:job_offer, category: frontend_category)
        create(:job_offer, category: qa_category)
      end

      it 'returns job offers with given categories' do
        get api_v1_job_offers_path, params: {
          by_category: [backend_category.name, frontend_category.name]
        }

        res = JSON.parse(response.body)
        expect(res.size).to eq(2)
      end
    end

    context 'with .by_technology scope' do
      let(:ruby_technology) { create(:technology, name: 'ruby') }
      let(:js_technology) { create(:technology, name: 'js') }
      let(:go_technology) { create(:technology, name: 'go') }

      before do
        create(:job_offer, technology: ruby_technology)
        create(:job_offer, technology: js_technology)
        create(:job_offer, technology: go_technology)
      end

      it 'returns job offers with given technologies' do
        get api_v1_job_offers_path, params: {
          by_technology: [ruby_technology.name, go_technology.name]
        }

        res = JSON.parse(response.body)
        expect(res.size).to eq(2)
      end
    end

    context 'with .by_remote scope' do
      before do
        create(:job_offer, remote: 5)
        create(:job_offer, remote: 0)

        get api_v1_job_offers_path, params: { by_remote: 5 }
      end

      it 'returns only remote job offers' do
        expect(JSON.parse(response.body).size).to eq(1)
        expect(JSON.parse(response.body)[0]['remote']).to eq(5)
      end
    end

    context 'with .by_travelling scope' do
      before do
        create(:job_offer, travelling: 'none')
        create(:job_offer, travelling: 'some')

        get api_v1_job_offers_path, params: { by_travelling: 'none' }
      end

      it 'returns job offers without travelling' do
        expect(JSON.parse(response.body).size).to eq(1)
        expect(JSON.parse(response.body)[0]['travelling']).to eq('none')
      end
    end

    context 'with .by_city scope' do
      let(:first_job_offer) { create(:job_offer) }
      let(:second_job_offer) { create(:job_offer) }
      let(:third_job_offer) { create(:job_offer) }

      before do
        first_job_offer.job_locations.create(attributes_for(:job_location, city: 'krakow'))
        second_job_offer.job_locations.create(attributes_for(:job_location, city: 'rzeszow'))
        third_job_offer.job_locations.create(attributes_for(:job_location, city: 'szczecin'))
      end

      it 'returns job offers from given cities' do
        get api_v1_job_offers_path, params: {
          by_city: %w[krakow szczecin]
        }

        expect(JSON.parse(response.body).size).to eq(2)
      end
    end

    context 'with .by_seniority scope' do
      before do
        create(:job_offer, seniority: 4)
        create(:job_offer, seniority: 3)

        get api_v1_job_offers_path, params: { by_seniority: 4 }
      end

      it 'returns job offers with seniority level of 4' do
        expect(JSON.parse(response.body).size).to eq(1)
        expect(JSON.parse(response.body)[0]['seniority']).to eq(4)
      end
    end

    context 'with .by_currency scope' do
      let(:first_job_offer) { create(:job_offer) }
      let(:second_job_offer) { create(:job_offer) }
      let(:third_job_offer) { create(:job_offer) }

      before do
        first_job_offer.job_contracts.create(attributes_for(:job_contract, currency: 'PLN'))
        second_job_offer.job_contracts.create(attributes_for(:job_contract, currency: 'EUR'))
        third_job_offer.job_contracts.create(attributes_for(:job_contract, currency: 'ARS'))
      end

      it 'returns job offers from given cities' do
        get api_v1_job_offers_path, params: {
          by_currency: %w[PLN ARS]
        }

        expect(JSON.parse(response.body).size).to eq(2)
      end
    end

    context 'with .by_employment scope' do
      let(:first_job_offer) { create(:job_offer) }
      let(:second_job_offer) { create(:job_offer) }
      let(:third_job_offer) { create(:job_offer) }

      before do
        first_job_offer.job_contracts.create(attributes_for(:job_contract, employment: 'uop'))
        second_job_offer.job_contracts.create(attributes_for(:job_contract, employment: 'b2b'))
        third_job_offer.job_contracts.create(
          attributes_for(:job_contract, employment: 'mandatory')
        )
      end

      it 'returns job offers with given employment type' do
        get api_v1_job_offers_path, params: {
          by_employment: %w[uop b2b]
        }

        expect(JSON.parse(response.body).size).to eq(2)
      end
    end

    context 'with .by_language scope' do
      let(:first_job_offer) { create(:job_offer) }
      let(:second_job_offer) { create(:job_offer) }
      let(:third_job_offer) { create(:job_offer) }

      before do
        first_job_offer.job_languages.create(
          attributes_for(:job_language, name: 'polish')
        )
        second_job_offer.job_languages.create(
          attributes_for(:job_language, name: 'english')
        )
        third_job_offer.job_languages.create(
          attributes_for(:job_language, name: 'czech')
        )
      end

      it 'returns job offers with given languages' do
        get api_v1_job_offers_path, params: {
          by_language: %w[polish czech]
        }

        expect(JSON.parse(response.body).size).to eq(2)
      end
    end

    context 'with .by_skill scope' do
      let(:first_job_offer) { create(:job_offer) }
      let(:second_job_offer) { create(:job_offer) }
      let(:third_job_offer) { create(:job_offer) }

      before do
        first_job_offer.job_skills.create( # should be included in response
          attributes_for(:job_skill, name: 'azure')
        )
        second_job_offer.job_skills.create( # should not be included in response
          attributes_for(:job_skill, name: 'gcp')
        )
        third_job_offer.job_skills.create( # should be included in response
          attributes_for(:job_skill, name: 'aws')
        )
      end

      it 'returns job offers with given languages' do
        get api_v1_job_offers_path, params: {
          by_skill: %w[azure aws]
        }

        expect(JSON.parse(response.body).size).to eq(2)
      end
    end

    context 'with .by_salary scope' do
      let(:first_job_offer) { create(:job_offer) }
      let(:second_job_offer) { create(:job_offer) }
      let(:third_job_offer) { create(:job_offer) }

      before do
        first_job_offer.job_contracts.create( # should be included in response
          attributes_for(:job_contract, from: 3500, to: 3600)
        )
        second_job_offer.job_contracts.create( # should not be included in response
          attributes_for(:job_contract, from: 1000, to: 2000)
        )
        second_job_offer.job_contracts.create( # should be included in response
          attributes_for(:job_contract, from: 4000, to: 5000)
        )
      end

      it 'returns job offers with given languages' do
        get api_v1_job_offers_path, params: {
          by_salary: {
            from: 3500,
            to: 5000
          }
        }

        expect(JSON.parse(response.body).size).to eq(2)
      end
    end

    context 'with ordering' do
      before do
        create(:job_offer, title: 'Senior Rails Developer', seniority: 5)
        create(:job_offer, title: 'Junior Rails Developer', seniority: 2)
        create(:job_offer, title: 'Engineering Manager', seniority: 3)
        create(:job_offer, title: 'Intern React Developer', seniority: 1)
      end

      it 'returns job offers sorted by title ascending' do
        get api_v1_job_offers_path, params: { sort: 'title' }

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
        get api_v1_job_offers_path, params: { sort: '-title' }

        expected_order = [
          'Senior Rails Developer',
          'Junior Rails Developer',
          'Intern React Developer',
          'Engineering Manager'
        ]
        response_order = JSON.parse(response.body).map { |offer| offer['title'] }

        expect(response_order).to match_array(expected_order)
      end

      it 'returns job offers sorted by seniority ascending' do
        get api_v1_job_offers_path, params: { sort: 'seniority' }

        expected_order = [1, 2, 3, 5]
        response_order = JSON.parse(response.body).map { |offer| offer['seniority'] }

        expect(response_order).to match_array(expected_order)
      end

      it 'returns job offers sorted by seniority descending' do
        get api_v1_job_offers_path, params: { sort: '-seniority' }

        expected_order = [5, 3, 2, 1]
        response_order = JSON.parse(response.body).map { |offer| offer['seniority'] }

        expect(response_order).to match_array(expected_order)
      end
    end

    context 'with multiple scopes combined' do
      before do
        create(:job_offer, seniority: 5, remote: 5) # should be included
        create(:job_offer, seniority: 5, remote: 5) # should be included
        create(:job_offer, seniority: 1, remote: 0)
        create(:job_offer, seniority: 1, remote: 5)

        get api_v1_job_offers_path, params: {
          by_seniority: 5,
          by_remote: 5
        }
      end

      it 'returns job offers with given seniority and remote' do
        expect(JSON.parse(response.body).size).to eq(2)
      end
    end

    # Spec depends on settings set in: config/initializers/pagy.rb
    context 'with pagination' do
      before do
        create_list(:job_offer, 10)
      end

      it 'returns results with default pagination settings' do
        get api_v1_job_offers_path

        expect(response.headers['Current-Page']).to eq('1')
        expect(response.headers['Total-Pages']).to eq('1')
        expect(response.headers['Page-Items']).to eq('25')
      end

      it 'user can change page and items count' do
        get api_v1_job_offers_path, params: { items: 5, page: 2 }

        expect(response.headers['Current-Page']).to eq('2')
        expect(response.headers['Total-Pages']).to eq('2')
        expect(response.headers['Page-Items']).to eq('5')
      end

      it 'returns 500 status on overflowing pages' do
        expect do
          get api_v1_job_offers_path,
              params: { page: 9999 }
        end.to raise_error(Pagy::OverflowError)
      end

      # Tu jest jescze taki babol, że mozna wpisac page: -1,
      # albo page: 'cos' i to wypierdala 500, `Pagy::VariableError`.
      #
      # Kurwa najlepsze że autor gema się kłóci jeszcze na githubie, ze jak
      # mozna cos takiego wpisac, to znaczy, że ktoś zjebał UI.
      # Jakoś handlowanie gdy Total-Pages to np: 5 i wpiszemy 6 to mozemy
      # sobie w opcjach zdecydować co się stanie, ale ponizej 0 i jak sie
      # wpisze stringa to juz źle zrobiony UI. O chuj chodzi typowi wgl.
      # XDDDDDDDDDDDDDDDDDDDDDDDDDDD
      #
      # https://github.com/ddnexus/pagy/issues/102
    end
  end

  describe 'GET #show' do
    context 'when job offer exists' do
      let!(:job_offer) { create(:job_offer) }

      it 'returns http success' do
        get api_v1_job_offer_path(id: job_offer.id)
        expect(response).to have_http_status(:ok)
      end

      it 'returns job offer' do
        get api_v1_job_offer_path(id: job_offer.id)
        expect(JSON.parse(response.body)['title']).to eq(job_offer.title)
      end
    end

    context 'when job offer doesn\'t exist' do
      it 'returns http not found', :realistic_error_responses do
        get api_v1_job_offer_path(id: 1)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #apply' do
    let(:job_offer) { create(:job_offer) }

    context 'without params' do
      it 'returns 400 http status', :realistic_error_responses do
        post apply_api_v1_job_offer_path(job_offer.id)
        expect(response).to have_http_status(:bad_request)
      end

      it 'raises ActionController::ParameterMissing' do
        expect { post apply_api_v1_job_offer_path(job_offer.id) }.to(
          raise_error(ActionController::ParameterMissing)
        )
      end
    end

    context 'when candidate is not signed in' do
      let(:candidate_email) { 'candidate1@example.com' }
      let(:valid_apply_params) do
        {
          first_name: 'Maciej',
          last_name: 'Biel',
          email: candidate_email,
          work_form: 'remote',
          city: 'Rzeszow',
          cv: 'link',
          contract: 'uop',
          start_time: 'now',
          working_hours: 'full'
        }
      end

      it 'applies on job offer with valid params' do
        post apply_api_v1_job_offer_path(job_offer.id), params: {
          apply: valid_apply_params
        }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['job_offer_id']).to eq(job_offer.id)
      end

      context 'when candidate tries to apply on the same offer' do
        let(:job_offer) { create(:job_offer) }
        let(:other_job_offer) { create(:job_offer) }

        before do
          job_offer.job_applications.create(
            attributes_for(:job_application, email: candidate_email)
          )
        end

        it 'returns error with custom message when applying on the same offer' do
          post apply_api_v1_job_offer_path(job_offer.id), params: {
            apply: valid_apply_params
          }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['errors']['status'][0]).to(
            eq('cannot apply on the same offer, when recruitment process is ongoing')
          )
        end
      end

      context 'when not signed in candidate applies with registered e-mail' do
        let(:candidate) do
          create(
            :candidate,
            email: 'maciej.biel@example.com',
            first_name: 'Maciej',
            last_name: 'Biel'
          )
        end
        let(:job_offer) { create(:job_offer) }

        it 'returns error with custom message' do
          post apply_api_v1_job_offer_path(job_offer.id), params: {
            apply: {
              first_name: 'Maciej',
              last_name: 'Biel',
              email: candidate.email,
              work_form: 'remote',
              city: 'Rzeszow',
              cv: 'link',
              contract: 'uop',
              start_time: 'now',
              working_hours: 'full'
            }
          }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['error']).to(
            eq('applying from registered e-mail requires signing in first')
          )
        end
      end
    end

    context 'when candidate is signed in' do
      let(:candidate) do
        create(
          :candidate,
          email: 'maciej.biel@example.com',
          first_name: 'Maciej',
          last_name: 'Biel'
        )
      end
      let(:login_candidate) do
        post api_v1_candidate_session_path, params: {
          email: candidate.email,
          password: candidate.password
        }
      end
      let(:auth_headers) { candidate.create_new_auth_token }
      let(:valid_apply_params) do
        {
          first_name: 'Maciej',
          last_name: 'Biel',
          email: 'random.email@example.com',
          work_form: 'remote',
          city: 'Rzeszow',
          cv: 'link',
          contract: 'uop',
          start_time: 'now',
          working_hours: 'full'
        }
      end

      it 'applies on job offer and replaces params with candidate data' do
        login_candidate
        post apply_api_v1_job_offer_path(job_offer.id), params: {
          apply: valid_apply_params
        }, headers: auth_headers

        res = JSON.parse(response.body)
        expect(response).to have_http_status(:created)
        expect(res['job_offer_id']).to eq(job_offer.id)
        expect(res['email']).to eq(candidate.email)
        expect(res['first_name']).to eq(candidate.first_name)
        expect(res['last_name']).to eq(candidate.last_name)
      end
    end
  end
end
