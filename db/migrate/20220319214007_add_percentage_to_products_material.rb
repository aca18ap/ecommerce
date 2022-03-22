class AddPercentageToProductsMaterial < ActiveRecord::Migration[6.1]
  def change
    add_column :products_materials, :percentage, :float
  end
end
