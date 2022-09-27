# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job::Skill, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:job_offer) }
  end

  describe 'validations' do
    describe 'name' do
      it { is_expected.to validate_presence_of(:name) }
    end

    describe 'level' do
      it { is_expected.to validate_presence_of(:level) }
      it { is_expected.to validate_numericality_of(:level) }

      it {
        is_expected.to validate_numericality_of(:level)
          .is_greater_than_or_equal_to(1)
      }

      it {
        is_expected.to validate_numericality_of(:level)
          .is_less_than_or_equal_to(5)
      }
    end
  end
end
