class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.text :description
      t.integer :clicks
      t.integer :rating
      t.boolean :hidden
      t.integer :rank

      t.timestamps
    end
  end
end
