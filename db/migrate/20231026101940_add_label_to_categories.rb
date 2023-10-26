class AddLabelToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :label, :string, null: false, default: ""
  end
end
