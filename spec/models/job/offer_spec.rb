# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job::Offer, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:job_skills).dependent(:destroy) }
    it { is_expected.to have_many(:job_skills_required).dependent(:destroy) }
    it { is_expected.to have_many(:job_benefits).dependent(:destroy) }
    it { is_expected.to have_many(:job_contracts).dependent(:destroy) }
    it { is_expected.to have_many(:job_locations).dependent(:destroy) }
    it { is_expected.to have_many(:job_contacts).dependent(:destroy) }
    it { is_expected.to have_many(:job_languages).dependent(:destroy) }
    it { is_expected.to have_one(:job_company).dependent(:destroy) }
    it { is_expected.to have_one(:job_equipment).dependent(:destroy) }
    it { is_expected.to belong_to(:category) }
    it { is_expected.to belong_to(:employer) }
    it { is_expected.to belong_to(:technology) }
  end

  describe 'validations' do
    describe 'title' do
      it { is_expected.to validate_presence_of(:title) }
    end

    describe 'seniority' do
      it { is_expected.to validate_presence_of(:seniority) }

      it {
        is_expected.to validate_numericality_of(:seniority)
          .is_greater_than_or_equal_to(1)
          .is_less_than_or_equal_to(5)
          .only_integer
      }
    end

    describe 'body' do
      it { is_expected.to validate_presence_of(:body) }
    end

    describe 'valid_until' do
      it { is_expected.to validate_presence_of(:valid_until) }

      context 'when valid_until is set in past' do
        let(:offer) { create(:job_offer_in_past) }

        it 'is invalid' do
          expect { offer }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end

    describe 'travelling' do
      it do
        is_expected.to validate_inclusion_of(:travelling)
          .in_array(Job::Offer::TRAVELLING_TYPES)
      end
    end

    describe 'remote' do
      it { is_expected.to validate_presence_of(:remote) }

      it {
        is_expected.to validate_numericality_of(:remote)
          .is_greater_than_or_equal_to(0)
          .is_less_than_or_equal_to(5)
          .only_integer
      }
    end

    describe 'required associations' do
      it { is_expected.to validate_presence_of(:job_skills) }
      it { is_expected.to validate_presence_of(:job_contracts) }
      it { is_expected.to validate_presence_of(:job_locations) }
      it { is_expected.to validate_presence_of(:job_company) }
      it { is_expected.to validate_presence_of(:job_equipment) }
      it { is_expected.to validate_presence_of(:job_languages) }
    end
  end

  describe 'nested attributes' do
    it { is_expected.to accept_nested_attributes_for(:job_company) }
    it { is_expected.to accept_nested_attributes_for(:job_equipment) }

    it do
      is_expected.to accept_nested_attributes_for(:job_skills)
        .allow_destroy(true)
    end

    it do
      is_expected.to accept_nested_attributes_for(:job_benefits)
        .allow_destroy(true)
    end

    it do
      is_expected.to accept_nested_attributes_for(:job_contracts)
        .allow_destroy(true)
    end

    it do
      is_expected.to accept_nested_attributes_for(:job_locations)
        .allow_destroy(true)
    end

    it do
      is_expected.to accept_nested_attributes_for(:job_contacts)
        .allow_destroy(true)
    end

    it do
      is_expected.to accept_nested_attributes_for(:job_languages)
        .allow_destroy(true)
    end
  end

  describe 'validates_associated' do
    let(:offer) { create(:job_offer) }

    it 'validates :job_skills' do
      offer.job_skills.build
      expect(offer.save).to eq(false)
    end

    it 'validates :job_benefits' do
      offer.job_benefits.build
      expect(offer.save).to eq(false)
    end

    it 'validates :job_contracts' do
      offer.job_contracts.build
      expect(offer.save).to eq(false)
    end

    it 'validates :job_locations' do
      offer.job_locations.build
      expect(offer.save).to eq(false)
    end

    it 'validates :job_contacts' do
      offer.job_contacts.build
      expect(offer.save).to eq(false)
    end

    it 'validates :job_languages' do
      offer.job_languages.build
      expect(offer.save).to eq(false)
    end

    it 'validates :job_equipment' do
      offer.build_job_equipment
      expect(offer.save).to eq(false)
    end

    it 'validates :job_company' do
      offer.build_job_company
      expect(offer.save).to eq(false)
    end
  end

  describe 'scopes' do
    describe '.is_active' do
      subject { described_class.is_active }

      let(:active_job_offer) { create(:job_offer) }
      let(:inactive_job_offer) { create(:job_offer, is_active: false) }
      let(:expired_job_offer) do
        create(:job_offer, valid_until: (Time.zone.now - 1.day), skip_validations: true)
      end

      it 'includes only active job offers' do
        is_expected.to include(active_job_offer)
      end

      it 'excludes inactive job offers' do
        is_expected.not_to include(inactive_job_offer)
      end

      it 'excludes expired job offers' do
        is_expected.not_to include(expired_job_offer)
      end
    end

    describe '.is_interview_online' do
      subject { described_class.is_interview_online(true) }

      let(:job_offer_with_interview) { create(:job_offer, interview_online: true) }
      let(:inactive_without_interview) { create(:job_offer, interview_online: false) }

      it 'includes only job offers with interview online' do
        is_expected.to include(job_offer_with_interview)
      end

      it 'excludes job offers without interview online' do
        is_expected.not_to include(inactive_without_interview)
      end
    end

    describe '.is_ua_supported' do
      subject { described_class.is_ua_supported(true) }

      let(:job_offer_with_ua) { create(:job_offer, ua_supported: true) }
      let(:job_offer_without_ua) { create(:job_offer, ua_supported: false) }

      it 'includes only job offers with ua support' do
        is_expected.to include(job_offer_with_ua)
      end

      it 'excludes job offers without ua support' do
        is_expected.not_to include(job_offer_without_ua)
      end
    end

    # WARNING - add case sesnsitiveness
    describe '.by_title' do
      subject { described_class.by_title('ruby on rails') }

      let(:first_job_offer) { create(:job_offer, title: 'senior ruby on rails dev') }
      let(:second_job_offer) { create(:job_offer, title: 'java developer') }

      it 'includes only job offers with given title' do
        is_expected.to include(first_job_offer)
      end

      it 'excludes job offers  with given title' do
        is_expected.not_to include(second_job_offer)
      end
    end

    describe '.by_remote' do
      subject { described_class.by_remote(5) }

      let(:remote_job_offer) { create(:job_offer, remote: 5) }
      let(:stationary_job_offer) { create(:job_offer, remote: 0) }

      it 'includes only fully remote job offers' do
        is_expected.to include(remote_job_offer)
      end

      it 'excludes stationary job offers' do
        is_expected.not_to include(stationary_job_offer)
      end
    end

    describe '.by_seniority' do
      subject { described_class.by_seniority(4) }

      let(:senior_job_offer) { create(:job_offer, seniority: 4) }
      let(:junior_job_offer) { create(:job_offer, seniority: 2) }

      it 'includes job offers only for seniors' do
        is_expected.to include(senior_job_offer)
      end

      it 'excludes job offers for juniors' do
        is_expected.not_to include(junior_job_offer)
      end
    end

    describe '.by_travelling' do
      subject { described_class.by_travelling('none') }

      let(:none_travelling_job_offer) { create(:job_offer, travelling: 'none') }
      let(:some_travelling_job_offer) { create(:job_offer, travelling: 'some') }

      it 'includes job offers without travelling' do
        is_expected.to include(none_travelling_job_offer)
      end

      it 'excludes job offers with some travelling' do
        is_expected.not_to include(some_travelling_job_offer)
      end
    end

    describe '.by_city' do
      subject { described_class.by_city(['krakow']) }

      let(:first_job_offer) { create(:job_offer) }
      let(:second_job_offer) { create(:job_offer) }

      before do
        first_job_offer.job_locations.create(attributes_for(:job_location, city: 'krakow'))
        second_job_offer.job_locations.create(attributes_for(:job_location, city: 'rzeszow'))
      end

      it 'includes job offers with locations in "krakow"' do
        is_expected.to include(first_job_offer)
      end

      it 'excludes job offers with different locations than "krakow"' do
        is_expected.not_to include(second_job_offer)
      end
    end

    describe '.by_category' do
      subject { described_class.by_category('backend') }

      let(:backend) { create(:category, name: 'backend') }
      let(:frontend) { create(:category, name: 'frontend') }
      let(:first_job_offer) { create(:job_offer, category: backend) }
      let(:second_job_offer) { create(:job_offer, category: frontend) }

      it 'includes job offers from "backend" category' do
        is_expected.to include(first_job_offer)
      end

      it 'excludes job offers different than "backend" category' do
        is_expected.not_to include(second_job_offer)
      end
    end

    describe '.by_technology' do
      subject { described_class.by_technology('ruby') }

      let(:ruby_technology) { create(:technology, name: 'ruby') }
      let(:js_technology) { create(:technology, name: 'js') }
      let(:first_job_offer) { create(:job_offer, technology: ruby_technology) }
      let(:second_job_offer) { create(:job_offer, technology: js_technology) }

      it 'includes job offers from "ruby" technology' do
        is_expected.to include(first_job_offer)
      end

      it 'excludes job offers different than "ruby" technology' do
        is_expected.not_to include(second_job_offer)
      end
    end

    # TODO - Refactor
    # WARNING - probably error prone
    # Relations specified in offer factory requires to create
    # at least one employment type, and it conflicts with this test.
    # To make this test pass, I have to provide different values than
    # in factory.
    describe '.by_currency' do
      subject { described_class.by_currency('PLN') }

      let(:first_job_offer) { create(:job_offer) }
      let(:second_job_offer) { create(:job_offer) }

      before do
        first_job_offer.job_contracts.create(attributes_for(:job_contract, currency: 'PLN'))
        second_job_offer.job_contracts.create(attributes_for(:job_contract, currency: 'EUR'))
      end

      it 'includes job offers with currency in "PLN"' do
        is_expected.to include(first_job_offer)
      end

      it 'excludes job offers with different currecny than "PLN"' do
        is_expected.not_to include(second_job_offer)
      end
    end

    # TODO - Refactor
    # WARNING - probably error prone
    # Relations specified in offer factory requires to create
    # at least one employment type, and it conflicts with this test.
    # To make this test pass, I have to provide different values than
    # in factory.
    describe '.by_employment' do
      subject { described_class.by_employment('uop') }

      let(:first_job_offer) { create(:job_offer) }
      let(:second_job_offer) { create(:job_offer) }

      before do
        first_job_offer.job_contracts.create(
          attributes_for(:job_contract, employment: 'uop')
        )
        second_job_offer.job_contracts.create(
          attributes_for(:job_contract, employment: 'b2b')
        )
      end

      it 'includes job offers with "uop" employment' do
        is_expected.to include(first_job_offer)
      end

      it 'excludes job offers with employment different than "uop"' do
        is_expected.not_to include(second_job_offer)
      end
    end

    # TODO - Refactor
    # WARNING - probably error prone
    # Relations specified in offer factory requires to create
    # at least one employment type, and it conflicts with this test.
    # To make this test pass, I have to provide different values than
    # in factory.
    describe '.by_salary' do
      subject { described_class.by_salary(3000, 4000) }

      let(:first_job_offer) { create(:job_offer) }
      let(:second_job_offer) { create(:job_offer) }

      before do
        first_job_offer.job_contracts.create(
          attributes_for(:job_contract, from: 3000, to: 4000)
        )
        second_job_offer.job_contracts.create(
          attributes_for(:job_contract, from: 1000, to: 2000)
        )
      end

      it 'includes job offers withing salary range' do
        is_expected.to include(first_job_offer)
      end

      it 'excludes job offers different than salary range' do
        is_expected.not_to include(second_job_offer)
      end
    end

    # TODO - Refactor
    # WARNING - probably error prone
    # Relations specified in offer factory requires to create
    # at least one employment type, and it conflicts with this test.
    # To make this test pass, I have to provide different values than
    # in factory.
    describe '.by_language' do
      subject { described_class.by_language('polish') }

      let(:first_job_offer) { create(:job_offer) }
      let(:second_job_offer) { create(:job_offer) }

      before do
        first_job_offer.job_languages.create(
          attributes_for(:job_language, name: 'polish')
        )
        second_job_offer.job_languages.create(
          attributes_for(:job_language, name: 'english')
        )
      end

      it 'includes job offers with "polish" languages' do
        is_expected.to include(first_job_offer)
      end

      it 'excludes job offers with employment different than "polish"' do
        is_expected.not_to include(second_job_offer)
      end
    end

    # TODO - Refactor
    # WARNING - probably error prone
    # Relations specified in offer factory requires to create
    # at least one employment type, and it conflicts with this test.
    # To make this test pass, I have to provide different values than
    # in factory.
    describe '.by_skill' do
      subject { described_class.by_skill(%w[azure aws]) }

      let(:first_job_offer) { create(:job_offer) }
      let(:second_job_offer) { create(:job_offer) }
      let(:third_job_offer) { create(:job_offer) }

      before do
        first_job_offer.job_skills.create(
          attributes_for(:job_skill, name: 'azure')
        )
        second_job_offer.job_skills.create(
          attributes_for(:job_skill, name: 'gcp')
        )
        third_job_offer.job_skills.create(
          attributes_for(:job_skill, name: 'aws')
        )
      end

      it 'includes job offers with "azure" and "aws" skills' do
        is_expected.to include(first_job_offer)
        is_expected.to include(third_job_offer)
      end

      it 'excludes job offers with skill different than "azure"' do
        is_expected.not_to include(second_job_offer)
      end
    end
  end

  context 'when job offer is created' do
    it 'saves title as slug' do
      title = 'senior ruby on rails developer'
      offer = create(:job_offer, title:)
      expect(offer.slug).to eq(title.parameterize)
    end

    it 'sets default travelling value when empty' do
      offer = create(:job_offer, travelling: nil)
      expect(offer.travelling).to eq('none')
    end
  end

  context 'when job offer is updated' do
    it 'updates title and slug' do
      old_title = 'mid ruby on rails developer'
      new_title = 'senior ruby on rails developer'
      offer = create(:job_offer, title: old_title)
      offer.update(title: new_title)
      expect(offer.slug).to eq(new_title.parameterize)
    end
  end

  describe '#to_param' do
    it 'overrides default to_param method' do
      title = 'senior ruby on rails developer'
      offer = create(:job_offer, title:)

      expect(offer.to_param).to eq("#{offer.id}-#{offer.slug}")
    end
  end
end
