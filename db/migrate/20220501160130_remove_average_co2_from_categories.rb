class RemoveAverageCo2FromCategories < ActiveRecord::Migration[6.1]
  def change
    remove_column :categories, :average_co2
  end
end
