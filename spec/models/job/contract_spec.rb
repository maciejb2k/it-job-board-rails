# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job::Contract, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:job_offer) }
  end

  describe 'validations' do
    describe 'employment' do
      it { is_expected.to validate_presence_of(:employment) }

      it {
        is_expected.to validate_inclusion_of(:employment)
          .in_array(%w[b2b uop mandatory])
      }
    end

    describe 'from' do
      it { is_expected.to validate_presence_of(:from) }

      it {
        is_expected.to validate_numericality_of(:from)
          .is_greater_than_or_equal_to(0)
          .is_less_than(BigDecimal(10**6))
      }
    end

    describe 'to' do
      it { is_expected.to validate_presence_of(:to) }

      it {
        is_expected.to validate_numericality_of(:to)
          .is_greater_than_or_equal_to(0)
          .is_less_than(BigDecimal(10**6))
      }
    end

    describe 'currency' do
      it { is_expected.to validate_presence_of(:currency) }
    end
  end
end
