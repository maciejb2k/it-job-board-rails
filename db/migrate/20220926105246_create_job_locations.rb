class CreateJobLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :job_locations, id: :uuid do |t|
      t.string :city, null: false
      t.string :street, null: false
      t.string :building_number, null: false
      t.string :zip_code, null: false
      t.string :country, null: false
      t.string :country_code, null: false

      t.timestamps
    end

    add_reference :job_locations, :job_offer, index: true, null: false, foreign_key: true, type: :uuid
  end
end
