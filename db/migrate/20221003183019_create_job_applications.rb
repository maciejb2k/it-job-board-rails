class CreateJobApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :job_applications, id: :uuid do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :phone
      t.string :cv, null: false
      t.jsonb :data, default: {}
      t.string :note
      t.string :work_form, null: false
      t.string :city, null: false
      t.string :contract, null: false
      t.string :start_time, null: false
      t.string :working_hours, null: false
      t.timestamp :closed_at
      
      # For employer
      t.boolean :starred, null: false, default: false
      
      t.timestamps
    end

    add_reference :job_applications, :job_offer, index: true, null: false, foreign_key: true, type: :uuid
    add_reference :job_applications, :candidate, index: true, foreign_key: true, type: :uuid
    add_index :job_applications, :data, using: :gin
  end
end
