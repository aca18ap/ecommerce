class AddLongitudeAndLatitudeToVisits < ActiveRecord::Migration[6.1]
  def change
    add_column :visits, :longitude, :float
    add_column :visits, :latitude, :float
    remove_column :visits, :location
  end
end
