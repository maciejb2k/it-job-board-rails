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
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:technology) }
  end

  describe 'validations' do
    describe 'title' do
      it { is_expected.to validate_presence_of(:title) }
    end

    describe 'seniority' do
      it { is_expected.to validate_presence_of(:seniority) }

      it {
        is_expected.to validate_numericality_of(:seniority)
          .is_greater_than_or_equal_to(1)
          .is_less_than_or_equal_to(4)
          .only_integer
      }
    end

    describe 'body' do
      it { is_expected.to validate_presence_of(:body) }
    end

    describe 'valid_until' do
      it { is_expected.to validate_presence_of(:valid_until) }
    end

    describe 'remote' do
      it { is_expected.to validate_presence_of(:remote) }

      it {
        is_expected.to validate_numericality_of(:remote)
          .is_greater_than_or_equal_to(0)
          .is_less_than_or_equal_to(5)
          .only_integer
      }
    end
  end
end
