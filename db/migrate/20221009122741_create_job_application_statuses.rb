class CreateJobApplicationStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :job_application_statuses, id: :uuid do |t|
      t.string :status, null: false
      t.string :note

      t.timestamps
    end

    add_reference :job_application_statuses, :job_application, index: true, null: false, foreign_key: true, type: :uuid
    add_index :job_application_statuses, [:job_application_id, :status], unique: true, name: 'index_job_application_statuses_unique'
  end
end
