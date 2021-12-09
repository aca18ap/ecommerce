class AddLatitudeLongitudeColumnToNewsletters < ActiveRecord::Migration[6.1]
  def change
    add_column :newsletters, :longitude, :float
    add_column :newsletters, :latitude, :float
  end
end
