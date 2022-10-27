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

      it {
        is_expected.to validate_numericality_of(:level)
          .is_greater_than_or_equal_to(1)
          .is_less_than_or_equal_to(5)
          .only_integer
      }
    end
  end

  describe '.only_required' do
    it 'includes only required skills' do
      skill = create(:job_skill, optional: false)
      expect(described_class.only_required).to include(skill)
    end

    it 'excludes optional skills' do
      skill = create(:job_skill, optional: true)
      expect(described_class.only_required).not_to include(skill)
    end
  end
end
