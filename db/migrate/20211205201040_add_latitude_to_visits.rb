class AddLatitudeToVisits < ActiveRecord::Migration[6.1]
  def change
    add_column :visits, :latitude, :float
  end
end
