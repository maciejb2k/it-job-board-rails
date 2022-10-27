# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Candidate, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:job_applications).dependent(:nullify) }
    it { is_expected.to have_one(:candidate_detail).dependent(:destroy) }
  end

  describe 'validations' do
    describe 'first_name' do
      it { is_expected.to validate_presence_of(:first_name) }
    end

    describe 'last_name' do
      it { is_expected.to validate_presence_of(:last_name) }
    end
  end
end
