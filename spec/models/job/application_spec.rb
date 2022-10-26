# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job::Application, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:job_offer) }
    it { is_expected.to belong_to(:candidate).optional }
    it { is_expected.to have_many(:job_application_statuses) }
  end

  describe 'validations' do
    describe 'first_name' do
      it { is_expected.to validate_presence_of(:first_name) }
    end

    describe 'last_name' do
      it { is_expected.to validate_presence_of(:last_name) }
    end

    describe 'email' do
      it { is_expected.to validate_presence_of(:email) }

      context 'when email format is incorrect' do
        it { expect(build(:job_application, email: 'wrongemail')).not_to be_valid }
        it { expect(build(:job_application, email: 'wrong.com')).not_to be_valid }
        it { expect(build(:job_application, email: '@wrong')).not_to be_valid }
        it { expect(build(:job_application, email: 'wrong@')).not_to be_valid }
      end

      context 'when email format is correct' do
        it { expect(build(:job_application, email: 'my.name@example.com')).to be_valid }
        it { expect(build(:job_application, email: 'email@example')).to be_valid }
      end
    end

    describe 'work_form' do
      it do
        is_expected.to validate_inclusion_of(:work_form)
          .in_array(Job::Application::WORK_FORM_CHOICES)
      end
    end

    describe 'city' do
      it { is_expected.to validate_presence_of(:city) }
    end

    describe 'cv' do
      it { is_expected.to validate_presence_of(:cv) }
    end

    describe 'contract' do
      it do
        is_expected.to validate_inclusion_of(:contract)
          .in_array(Job::Contract::CONTRACT_TYPES)
      end
    end

    describe 'start_time' do
      it do
        is_expected.to validate_inclusion_of(:start_time)
          .in_array(Job::Application::START_TIME_CHOICES)
      end
    end

    describe 'working_hours' do
      it do
        is_expected.to validate_inclusion_of(:working_hours)
          .in_array(Job::Application::WORKING_HOURS_CHOICES)
      end
    end
  end

  context 'when new application is created' do
    let(:application) { create(:job_application) }

    it 'creates new status associated to it' do
      expect(application.job_application_statuses).to exist
    end

    it 'new status name equals to "new"' do
      expect(application.job_application_statuses.first.status).to eq('new')
    end
  end

  describe 'candidate applies for job offer' do
    let(:candidate) { create(:candidate) }
    let(:offer) { create(:job_offer) }

    context 'when the user has not yet applied for the job offer' do
      let(:application) do
        create(:job_application, email: candidate.email, job_offer: offer)
      end

      it { expect(application).to be_valid }
    end

    context 'when the user already applied for the same job offer' do
      let(:application_first) do
        create(:job_application, email: candidate.email, job_offer: offer)
      end
      let(:application_second) do
        create(:job_application, email: candidate.email, job_offer: offer)
      end

      it 'raises validation error' do
        expect(application_first).to be_valid
        expect { application_second }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
