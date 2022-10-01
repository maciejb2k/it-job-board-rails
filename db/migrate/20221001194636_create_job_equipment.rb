class CreateJobEquipment < ActiveRecord::Migration[7.0]
  def change
    create_table :job_equipment do |t|
      t.string :computer, null: false
      t.integer :monitor, null: false, default: 1
      t.boolean :linux, null: false, default: false
      t.boolean :mac_os, null: false, default: false
      t.boolean :windows, null: false, default: false

      t.timestamps
    end
    
    add_reference :job_equipment, :job_offer, index: true, null: false, foreign_key: true
  end
end
