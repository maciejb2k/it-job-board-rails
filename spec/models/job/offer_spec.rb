# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job::Offer, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:job_skills) }
    it { is_expected.to have_many(:job_benefits) }
    it { is_expected.to have_many(:job_contracts) }
    it { is_expected.to have_many(:job_locations) }
    it { is_expected.to have_many(:job_companies) }
    it { is_expected.to have_many(:job_contacts) }
    it { is_expected.to have_many(:job_languages) }
  end
end
