# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job::Contact, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:job_offer) }
  end

  describe 'validations' do
    describe 'first_name' do
      it { is_expected.to validate_presence_of(:first_name) }
    end

    describe 'last_name' do
      it { is_expected.to validate_presence_of(:last_name) }
    end

    describe 'email' do
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.not_to allow_value('invalid.test.com').for(:email) }
      it { is_expected.to allow_value('test@test').for(:email) }
    end
  end
end
