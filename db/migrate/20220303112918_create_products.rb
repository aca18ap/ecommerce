class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.float :mass
      t.string :type
      t.string :url
      t.string :manufacturer
      t.string :manufacturer_country
      t.float :co2_produced

      t.timestamps
    end
  end
end
