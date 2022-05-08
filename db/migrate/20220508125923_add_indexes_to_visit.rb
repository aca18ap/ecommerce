class AddIndexesToVisit < ActiveRecord::Migration[6.1]
  def change
    add_index :visits, :path
  end
end
