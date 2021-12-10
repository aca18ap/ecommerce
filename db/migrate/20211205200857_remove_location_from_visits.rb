class RemoveLocationFromVisits < ActiveRecord::Migration[6.1]
  def change
    remove_column :visits, :location, :string
  end
end
