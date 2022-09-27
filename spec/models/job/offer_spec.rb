# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job::Offer, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:job_skills) }
    it { is_expected.to have_many(:job_benefits) }
    it { is_expected.to have_many(:job_contracts) }
    it { is_expected.to have_many(:job_locations) }
    it { is_expected.to have_many(:job_companies) }
    it { is_expected.to have_many(:job_contacts) }
    it { is_expected.to have_many(:job_languages) }

    it { is_expected.to belong_to(:category) }
    it { is_expected.to belong_to(:technology) }
  end

  describe 'validations' do
    describe 'title' do
      it { is_expected.to validate_presence_of(:title) }
    end

    describe 'seniority' do
      it { is_expected.to validate_presence_of(:seniority) }
      it { is_expected.to validate_numericality_of(:seniority) }

      it {
        is_expected.to validate_numericality_of(:seniority)
          .is_greater_than_or_equal_to(1)
      }

      it {
        is_expected.to validate_numericality_of(:seniority)
          .is_less_than_or_equal_to(4)
      }
    end

    describe 'body' do
      it { is_expected.to validate_presence_of(:body) }
    end

    describe 'valid_until' do
      it { is_expected.to validate_presence_of(:valid_until) }
    end

    describe 'status' do
      it { is_expected.to validate_presence_of(:status) }
    end

    describe 'remote' do
      it { is_expected.to validate_presence_of(:remote) }
      it { is_expected.to validate_numericality_of(:remote) }

      it {
        is_expected.to validate_numericality_of(:remote)
          .is_greater_than_or_equal_to(1)
      }

      it {
        is_expected.to validate_numericality_of(:remote)
          .is_less_than_or_equal_to(5)
      }
    end

    describe 'hybrid' do
      it { is_expected.to validate_presence_of(:hybrid) }
      it { is_expected.to allow_value(%w[true false]).for(:hybrid) }
      it { is_expected.not_to allow_value(nil).for(:hybrid) }
    end

    describe 'interview_online' do
      it { is_expected.to validate_presence_of(:interview_online) }
      it { is_expected.to allow_value(%w[true false]).for(:interview_online) }
      it { is_expected.not_to allow_value(nil).for(:interview_online) }
    end
  end
end
