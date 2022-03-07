class AddColumnsToBusiness < ActiveRecord::Migration[6.1]
  def change
    add_column :businesses, :name, :string, null: false
    add_column :businesses, :description, :string
  end
end
