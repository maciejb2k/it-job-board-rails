require 'rails_helper'

RSpec.describe Job::ApplicationStatus, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:job_application) }
  end

  describe 'validations' do
    describe 'status' do
      it do
        is_expected.to validate_inclusion_of(:status)
          .in_array(Job::ApplicationStatus::APPLICATION_STATUSES)
      end
    end

    # describe 'job_application' do
    #   it do
    #     is_expected.to validate_uniqueness_of(:job_application)
    #       .scoped_to(:job_application_id, :status)
    #   end
    # end

    context 'when closing application' do
      let(:application) { create(:job_application) }
      let(:application_status) do
        create(
          :job_application_status,
          status: 'hired',
          job_application: application
        )
      end

      it 'updates parent closed_at attr' do
        expect(application.closed_at).not_to be nil
      end
    end
  end
end
