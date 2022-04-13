class CreateAffiliateProductViews < ActiveRecord::Migration[6.1]
  def change
    create_table :affiliate_product_views do |t|
      t.references :product, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.timestamps
    end
  end
end