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
      it { is_expected.to validate_numericality_of(:size) }

      it {
        is_expected.to validate_numericality_of(:size)
          .is_greater_than_or_equal_to(0)
      }
    end

    describe 'data' do
      it { is_expected.to validate_presence_of(:data) }
    end
  end
end
