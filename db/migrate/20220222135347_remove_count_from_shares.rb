class RemoveCountFromShares < ActiveRecord::Migration[6.1]
  def change
    remove_column :shares, :count
  end
end
