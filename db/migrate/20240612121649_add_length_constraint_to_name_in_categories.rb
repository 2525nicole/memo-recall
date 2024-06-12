class AddLengthConstraintToNameInCategories < ActiveRecord::Migration[7.1]
  def change
    change_column :categories, :name, :string, limit: 24
  end
end
