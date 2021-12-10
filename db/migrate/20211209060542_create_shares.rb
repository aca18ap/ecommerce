class CreateShares < ActiveRecord::Migration[6.1]
  def change
    create_table :shares do |t|
      t.integer :count
      t.string :social

      t.timestamps
    end
  end
end
