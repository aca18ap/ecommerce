class AddIndexesToReview < ActiveRecord::Migration[6.1]
  def change
    add_index :reviews, :rank
    add_index :reviews, :rating
  end
end
