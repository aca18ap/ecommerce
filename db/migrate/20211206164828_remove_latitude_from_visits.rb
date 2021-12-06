class RemoveLatitudeFromVisits < ActiveRecord::Migration[6.1]
  def change
    remove_column :visits, :latitude, :float
  end
end
