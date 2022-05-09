class AddIndexesToShare < ActiveRecord::Migration[6.1]
  def change
    add_index :shares, [:feature, :social]
  end
end
