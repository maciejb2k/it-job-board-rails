class CreateJobLanguages < ActiveRecord::Migration[7.0]
  def change
    create_table :job_languages, id: :uuid do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.string :proficiency

      t.timestamps
    end

    add_reference :job_languages, :job_offer, index: true, null: false, foreign_key: true, type: :uuid
  end
end
