class AddBusinessIdToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :business_id, :bigint, null: true
  end
end
