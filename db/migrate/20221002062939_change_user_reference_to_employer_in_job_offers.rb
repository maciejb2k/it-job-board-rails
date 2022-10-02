class ChangeUserReferenceToEmployerInJobOffers < ActiveRecord::Migration[7.0]
  def change
    remove_reference :job_offers, :user, index: true, null: false, foreign_key: true, type: :uuid
    add_reference :job_offers, :employer, index: true, null: false, foreign_key: true, type: :uuid
  end
end
