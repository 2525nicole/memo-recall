class ChangeCategoryNameLimitTo15 < ActiveRecord::Migration[7.1]
  def change
    change_column :categories, :name, :string, limit: 15
  end
end
