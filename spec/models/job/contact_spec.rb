# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job::Contact, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:job_offer) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_numericality_of(:phone) }
    it { is_expected.to validate_numericality_of(:phone).only_integer }
  end
end
