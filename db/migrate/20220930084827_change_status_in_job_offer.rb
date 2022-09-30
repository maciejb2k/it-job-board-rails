class ChangeStatusInJobOffer < ActiveRecord::Migration[7.0]
  def up
    remove_column :job_offers, :status
    add_column :job_offers, :is_active, :boolean, null: false, default: true
  end
  
  def down
    remove_column :job_offers, :is_active
    add_column :job_offers, :status, :string, null: false, default: ''
  end
end
