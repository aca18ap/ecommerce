class AddMeanCo2ToCategory < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :mean_co2, :float, null: false, default: 0
  end
end
