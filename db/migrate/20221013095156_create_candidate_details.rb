class CreateCandidateDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :candidate_details, id: :uuid do |t|
      t.string :photo
      t.string :location, null: false
      t.string :seniority, null: false
      t.string :status, null: false
      t.string :specialization, null: false
      t.string :position, null: false
      t.integer :salary_from
      t.integer :salary_to
      t.string :currency
      t.boolean :hide_salary, null: false, default: false
      t.string :industry
      t.string :carrer_path
      t.string :technology
      
      t.timestamps
    end

    add_reference :candidate_details, :candidate, index: { unique: true }, null: false, foreign_key: true, type: :uuid
  end
end
