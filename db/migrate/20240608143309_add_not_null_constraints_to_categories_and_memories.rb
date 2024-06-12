class AddNotNullConstraintsToCategoriesAndMemories < ActiveRecord::Migration[7.1]
  def change
    change_column_null :categories, :name, false
    change_column_null :memories, :content, false
  end
end
