class AddFeaturesToJobOffers < ActiveRecord::Migration[7.0]
  def change
    # :job_offers
    add_column :job_offers, :uuid, :uuid, null: false, default: "uuid_generate_v4()"
    add_column :job_offers, :slug, :string, null:false
    add_column :job_offers, :travelling, :string, null: false
    add_column :job_offers, :ua_supported, :boolean, null: false, default: false

    # :job_languages
    add_column :job_languages, :required, :boolean, null: false, default: false
    
    # :job_contracts
    add_column :job_contracts, :paid_vacation, :boolean, null: false, default: false
    add_column :job_contracts, :payment_period, :string, null: false
  end
end
