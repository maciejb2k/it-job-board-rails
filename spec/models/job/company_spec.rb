# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job::Company, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:job_offer) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:logo) }
    it { is_expected.to validate_presence_of(:size) }
    it { is_expected.to validate_numericality_of(:size) }
    it { is_expected.to validate_numericality_of(:size).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_presence_of(:data) }
  end
end
