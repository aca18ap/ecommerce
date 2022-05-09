class AddIndexesToRegistration < ActiveRecord::Migration[6.1]
  def change
    add_index :registrations, :vocation
  end
end
