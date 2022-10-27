# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job::Language, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:job_offer) }
  end

  describe 'validations' do
    describe 'name' do
      it { is_expected.to validate_presence_of(:name) }
    end

    describe 'code' do
      it { is_expected.to validate_presence_of(:code) }
    end

    describe 'proficiency' do
      it do
        is_expected.to validate_inclusion_of(:proficiency)
          .in_array(Job::Language::PROFICIENCY_TYPES)
      end
    end
  end
end
