class RemoveHybridFromJobOffer < ActiveRecord::Migration[7.0]
  def change
    remove_column :job_offers, :hybrid, :boolean, null: false, default: false
  end
end
