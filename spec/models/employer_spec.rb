# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Employer, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:job_offers).dependent(:destroy) }
  end
end
