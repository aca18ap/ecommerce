class AddIdToPurchaseHistories < ActiveRecord::Migration[6.1]
  def change
    add_column :purchase_histories, :id, :primary_key
  end
end
