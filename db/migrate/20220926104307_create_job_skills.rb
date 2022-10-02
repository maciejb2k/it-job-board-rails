class CreateJobSkills < ActiveRecord::Migration[7.0]
  def change
    create_table :job_skills, id: :uuid do |t|
      t.string :name, null: false
      t.integer :level, null: false
      t.boolean :optional, null: false, default: false

      t.timestamps
    end

    add_reference :job_skills, :job_offer, index: true, null: false, foreign_key: true, type: :uuid
  end
end
