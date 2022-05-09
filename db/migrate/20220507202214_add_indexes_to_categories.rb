class AddIndexesToCategories < ActiveRecord::Migration[6.1]
  def change
    add_index :categories, :name
  end
end
