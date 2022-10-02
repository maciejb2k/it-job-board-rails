class CreateJobContracts < ActiveRecord::Migration[7.0]
  def change
    create_table :job_contracts, id: :uuid do |t|
      t.string :type, null: false
      t.boolean :hide_salary, null: false, default: false
      t.decimal :from, null: false, precision: 8, scale: 2 
      t.decimal :to, null: false, precision: 8, scale: 2
      t.string :currency, null: false

      t.timestamps
    end

    add_reference :job_contracts, :job_offer, index: true, null: false, foreign_key: true, type: :uuid
  end
end
