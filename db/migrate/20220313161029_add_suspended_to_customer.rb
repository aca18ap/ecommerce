class AddSuspendedToCustomer < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :suspended, :boolean, null: false, :default => false
  end
end
