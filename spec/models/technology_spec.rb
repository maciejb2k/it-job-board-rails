# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Technology, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:job_offers) }
  end

  describe 'validations' do
    describe 'name' do
      it { is_expected.to validate_presence_of(:name) }
    end
  end
end
