class RenameTypeInJobContract < ActiveRecord::Migration[7.0]
  def change
    rename_column :job_contracts, :type, :employment
  end
end
