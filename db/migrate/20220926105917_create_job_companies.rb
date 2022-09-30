class CreateJobCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :job_companies do |t|
      t.string :name, null: false
      t.string :logo, null: false
      t.integer :size, null: false, default: 0
      t.jsonb :data, null: false, default: {}

      t.timestamps
    end

    add_reference :job_companies, :job_offer, index: true, null: false, foreign_key: true
    add_index :job_companies, :data, using: :gin
  end
end
