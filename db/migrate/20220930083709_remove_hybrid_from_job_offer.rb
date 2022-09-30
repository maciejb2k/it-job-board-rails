class RemoveHybridFromJobOffer < ActiveRecord::Migration[7.0]
  def change
    remove_column :job_offers, :hybrid
  end
end
