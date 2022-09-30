# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job::Location, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:job_offer) }
  end

  describe 'validations' do
    describe 'city' do
      it { is_expected.to validate_presence_of(:city) }
    end

    describe 'street' do
      it { is_expected.to validate_presence_of(:street) }
    end

    describe 'building_number' do
      it { is_expected.to validate_presence_of(:building_number) }
    end

    describe 'zip_code' do
      it { is_expected.to validate_presence_of(:zip_code) }
    end

    describe 'country' do
      it { is_expected.to validate_presence_of(:country) }
    end

    describe 'country_code' do
      it { is_expected.to validate_presence_of(:country_code) }
    end
  end
end
