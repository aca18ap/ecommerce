class AddAverageCo2ToCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :average_co2, :float
  end
end
