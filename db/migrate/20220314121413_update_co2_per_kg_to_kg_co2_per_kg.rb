class UpdateCo2PerKgToKgCo2PerKg < ActiveRecord::Migration[6.1]
  def change
    rename_column :materials, :co2_per_kg, :kg_co2_per_kg
  end
end
