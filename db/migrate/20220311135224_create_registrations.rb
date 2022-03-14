class CreateRegistrations < ActiveRecord::Migration[6.1]
  def change
    create_table :registrations do |t|
      t.float :longitude
      t.float :latitude
      t.integer :vocation, null: false

      t.timestamps
    end
  end
end
