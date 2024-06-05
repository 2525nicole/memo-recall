class AddCategoryIdToMemories < ActiveRecord::Migration[7.1]
  def change
    add_reference :memories, :category, null: true, foreign_key: true
  end
end
