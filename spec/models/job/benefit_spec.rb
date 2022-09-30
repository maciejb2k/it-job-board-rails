# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job::Benefit, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:job_offer) }
  end

  describe 'validations' do
    describe 'group' do
      it { is_expected.to validate_presence_of(:group) }
    end

    describe 'name' do
      it { is_expected.to validate_presence_of(:name) }
    end
  end
end
