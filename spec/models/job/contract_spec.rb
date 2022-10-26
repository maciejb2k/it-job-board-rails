# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job::Contract, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:job_offer) }
  end

  describe 'validations' do
    describe 'employment' do
      it do
        is_expected.to validate_inclusion_of(:employment)
          .in_array(Job::Contract::CONTRACT_TYPES)
      end
    end

    describe 'from' do
      it { is_expected.to validate_presence_of(:from) }

      it do
        is_expected.to validate_numericality_of(:from)
          .is_greater_than_or_equal_to(0)
          .is_less_than(BigDecimal(10**6))
      end
    end

    describe 'to' do
      it { is_expected.to validate_presence_of(:to) }

      it do
        is_expected.to validate_numericality_of(:to)
          .is_greater_than_or_equal_to(0)
          .is_less_than(BigDecimal(10**6))
      end
    end

    describe 'currency' do
      it { is_expected.to validate_presence_of(:currency) }
    end

    describe 'payment_period' do
      it do
        is_expected.to validate_inclusion_of(:payment_period)
          .in_array(Job::Contract::PAYMENT_TYPES)
      end
    end

    context 'when starting salary is greater than ending salary' do
      let(:contract) { create(:job_contract, from: 1000, to: 999) }

      it 'is invalid' do
        expect { contract }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when starting salary is equal to ending salary' do
      let(:contract) { create(:job_contract, from: 1000, to: 1000) }

      it 'is invalid' do
        expect { contract }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when ending salary is greater than starting salary' do
      let(:contract) { create(:job_contract, from: 1000, to: 2000) }

      it 'is valid' do
        expect(contract).to be_valid
      end
    end
  end
end
