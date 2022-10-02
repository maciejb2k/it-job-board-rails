class AddTechnologyIdToJobOffer < ActiveRecord::Migration[7.0]
  def change
    add_reference :job_offers, :technology, index: true, null: false, foreign_key: true, type: :uuid
  end
end
