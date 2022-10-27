# frozen_string_literal: true

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

      it do
        # nie mam siły do tej kurwy
        expect(create(:in_progress_job_application_status)).to validate_uniqueness_of(:status)
          .scoped_to(%i[job_application_id])
          .with_message('cannot set the same status twice')
      end

      # https://github.com/thoughtbot/shoulda-matchers/issues/600
      # Zaraz coś rozpierdole.
      # Sam ten kodzik wypierdala `PG::NotNullViolation: ERROR:`,
      # mimo, że wszystko wygląda git, a autor pisze w issue,
      # że jakiś dziwny edge case i zamyka XDDD???
      #
      # it do
      #   is_expected.to validate_uniqueness_of(:status)
      #     .scoped_to(%i[job_application_id])
      # end
    end
  end

  context 'when status is updated' do
    let(:application) { create(:job_application) }

    context 'when new application status is :in_progress' do
      let(:application_status) do
        build(
          :in_progress_job_application_status,
          job_application: application
        )
      end

      before do
        application_status.save!
      end

      it 'doesn\'t update parent closed_at attr' do
        expect(application.closed_at).to be(nil)
      end
    end

    %i[hired resigned rejected].each do |status|
      context "when new application status is :#{status}" do
        let(:application_status) do
          build(
            "#{status}_job_application_status".to_sym,
            job_application: application
          )
        end

        before do
          application_status.save!
        end

        it 'updates parent closed_at attr' do
          expect(application.closed_at).not_to be(nil)
        end
      end
    end

    context 'when application is closed and user tries to set new :in_progress status' do
      let(:hired_application_status) do
        build(
          :hired_job_application_status,
          job_application: application
        )
      end
      let(:in_progress_application_status) do
        build(
          :in_progress_job_application_status,
          job_application: application
        )
      end

      before do
        hired_application_status.save!
      end

      it 'raises validation error' do
        expect { in_progress_application_status.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
