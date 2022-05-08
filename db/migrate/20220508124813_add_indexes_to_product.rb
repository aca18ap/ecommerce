class AddIndexesToProduct < ActiveRecord::Migration[6.1]
  def change
    add_index :products, :business_id
    add_index :products, :category_id
    add_index :products, :name
    add_index :products, :co2_produced
    add_index :products, :price
    add_index :products, :kg_co2_per_pounds
  end
end
