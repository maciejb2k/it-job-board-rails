class CreateJobContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :job_contacts do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :phone 

      t.timestamps
    end
    
    add_reference :job_contacts, :job_offer, index: true, null: false, foreign_key: true
  end
end
