class AddCategoryIdToJobOffer < ActiveRecord::Migration[7.0]
  def change
    add_reference :job_offers, :category, index: true, null: false, foreign_key: true
  end
end
