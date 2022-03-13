class CreateProductsMaterials < ActiveRecord::Migration[6.1]
  def change
    create_table :products_materials do |t|
      t.references :product, null: false, foreign_key: true
      t.references :material, null: false, foreign_key: true

      t.timestamps
    end
  end
end
