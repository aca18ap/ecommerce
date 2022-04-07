class AddFieldsToProduct < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :price, :float, null: false, default: 0
  end
end
