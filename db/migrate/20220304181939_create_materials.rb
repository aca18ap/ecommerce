class CreateMaterials < ActiveRecord::Migration[6.1]
  def change
    create_table :materials do |t|
      t.string :name
      t.float :co2_per_kg

      t.timestamps
    end
  end
end
