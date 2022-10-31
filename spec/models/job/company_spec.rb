# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job::Company, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:job_offer) }
  end

  describe 'validations' do
    describe 'name' do
      it { is_expected.to validate_presence_of(:name) }
    end

    describe 'logo' do
      it { is_expected.to validate_presence_of(:logo) }
    end

    describe 'size' do
      it { is_expected.to validate_presence_of(:size) }

      it {
        is_expected.to validate_numericality_of(:size)
          .is_greater_than_or_equal_to(0)
          .only_integer
      }
    end

    describe 'data' do
      context 'with invalid json' do
        let_it_be(:job_company) { build(:job_company, data: '{}') }

        it 'raises validation error' do
          expect(job_company).not_to be_valid
        end
      end

      context 'with valid json' do
        let_it_be(:job_company) { build(:job_company, data: '{"links": []}') }

        it 'passes validation' do
          expect(job_company).to be_valid
        end
      end
    end
  end
end
