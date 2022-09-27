# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job::Contract, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:job_offer) }
  end

  describe 'validations' do
    describe 'type' do
      it { is_expected.to validate_presence_of(:type) }
    end

    describe 'hide_salary' do
      it { is_expected.to validate_presence_of(:hide_salary) }
      it { is_expected.to allow_value(%w[true false]).for(:hide_salary) }
    end

    describe 'from' do
      it { is_expected.to validate_presence_of(:from) }

      it {
        is_expected.to validate_numericality_of(:from)
          .is_greater_than_or_equal_to(0)
      }

      it {
        is_expected.to validate_numericality_of(:from)
          .is_less_than(BigDecimal(10**6))
      }
    end

    describe 'to' do
      it { is_expected.to validate_presence_of(:to) }

      it {
        is_expected.to validate_numericality_of(:to)
          .is_greater_than_or_equal_to(0)
      }

      it {
        is_expected.to validate_numericality_of(:to)
          .is_less_than(BigDecimal(10**6))
      }
    end

    describe 'currency' do
      it { is_expected.to validate_presence_of(:currency) }
    end
  end
end
