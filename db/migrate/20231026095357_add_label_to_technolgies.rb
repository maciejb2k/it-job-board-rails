class AddLabelToTechnolgies < ActiveRecord::Migration[7.0]
  def change
    add_column :technologies, :label, :string, null: false, default: ""
  end
end
