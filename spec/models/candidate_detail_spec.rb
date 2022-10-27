# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CandidateDetail, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:candidate) }
  end

  describe 'validations' do
    describe 'location' do
      it { is_expected.to validate_presence_of(:location) }
    end

    describe 'seniority' do
      it { is_expected.to validate_presence_of(:seniority) }

      it do
        is_expected.to validate_numericality_of(:seniority)
          .is_greater_than_or_equal_to(1)
          .is_less_than_or_equal_to(5)
          .only_integer
      end
    end

    describe 'salary' do
      describe 'salary_from' do
        it { is_expected.to validate_presence_of(:salary_from) }

        it do
          is_expected.to validate_numericality_of(:salary_from)
            .is_greater_than_or_equal_to(0)
            .only_integer
        end
      end

      describe 'salary_to' do
        it { is_expected.to validate_presence_of(:salary_to) }

        it do
          is_expected.to validate_numericality_of(:salary_to)
            .is_greater_than_or_equal_to(0)
            .only_integer
        end
      end

      context 'when starting salary is greater than ending salary' do
        let(:candidate_detail) { create(:candidate_detail, salary_from: 1000, salary_to: 999) }

        it 'is invalid' do
          expect { candidate_detail }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context 'when starting salary is equal to ending salary' do
        let(:candidate_detail) { create(:candidate_detail, salary_from: 1000, salary_to: 1000) }

        it 'is invalid' do
          expect { candidate_detail }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context 'when ending salary is greater than starting salary' do
        let(:candidate_detail) { create(:candidate_detail, salary_from: 1000, salary_to: 2000) }

        it 'is valid' do
          expect(candidate_detail).to be_valid
        end
      end
    end

    describe 'status' do
      it { is_expected.to validate_presence_of(:status) }
    end

    describe 'specialization' do
      it { is_expected.to validate_presence_of(:specialization) }
    end

    describe 'position' do
      it { is_expected.to validate_presence_of(:position) }
    end

    describe 'candidate' do
      let(:candidate_detail) { create(:candidate_detail) }

      it { expect(candidate_detail).to validate_uniqueness_of(:candidate) }
    end
  end
end
