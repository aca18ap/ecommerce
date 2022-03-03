class RenameTypeToCategory < ActiveRecord::Migration[6.1]
  def change
    rename_column :products, :type, :category
  end
end
