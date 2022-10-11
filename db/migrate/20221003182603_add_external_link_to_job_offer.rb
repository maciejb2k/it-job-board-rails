class AddExternalLinkToJobOffer < ActiveRecord::Migration[7.0]
  def change
    add_column :job_offers, :external_link, :string
  end
end
