class CreateJobBenefits < ActiveRecord::Migration[7.0]
  def change
    create_table :job_benefits do |t|
      t.string :group, null: false
      t.string :name, null: false
      
      t.timestamps
    end

    add_reference :job_benefits, :job_offer, index: true, null: false, foreign_key: true
  end
end
