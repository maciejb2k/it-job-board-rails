class CreateJobOffers < ActiveRecord::Migration[7.0]
  def change
    create_table :job_offers, id: :uuid do |t|
      t.string :title, null: false
      t.integer :seniority, null: false
      t.text :body, null: false, default: ''
      t.timestamp :valid_until, null: false
      t.string :status, null: false
      t.string :rodo

      t.integer :remote, null: false, default: 0
      t.boolean :hybrid, null: false, default: false

      t.boolean :interview_online, null:false, default: true

      t.jsonb :data, null:false, default: {}

      t.timestamps
    end

    add_reference :job_offers, :user, index: true, null: false, foreign_key: true, type: :uuid
    add_index :job_offers, :data, using: :gin
  end
end
