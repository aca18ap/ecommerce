class AddLocationToVisits < ActiveRecord::Migration[6.1]
  def change
    add_column :visits, :location, :string
  end
end
