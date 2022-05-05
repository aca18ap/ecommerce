class AddKgCo2PerPoundToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :kg_co2_per_pounds, :float
  end
end
