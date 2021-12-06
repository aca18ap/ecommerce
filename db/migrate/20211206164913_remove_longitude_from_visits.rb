class RemoveLongitudeFromVisits < ActiveRecord::Migration[6.1]
  def change
    remove_column :visits, :longitude, :float
  end
end
