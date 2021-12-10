class AddLongitudeToVisits < ActiveRecord::Migration[6.1]
  def change
    add_column :visits, :longitude, :float
  end
end
