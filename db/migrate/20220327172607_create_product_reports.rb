class CreateProductReports < ActiveRecord::Migration[6.1]
  def change
    create_table :product_reports do |t|
      t.references :product, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.string :content, null: false

      t.timestamps
    end
  end
end
