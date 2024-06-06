class AddUniqueIndexToCategoriesNameAndUserId < ActiveRecord::Migration[7.1]
  def change
    add_index :categories, [:user_id, :name], unique: true
  end
end
