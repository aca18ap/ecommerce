class AddConstraintsToReviews < ActiveRecord::Migration[6.1]
  def change
    change_column_default(:reviews, :clicks, from: nil, to: 0)
    change_column_default(:reviews, :rating, from: nil, to: 0)
    change_column_default(:reviews, :rank, from: nil, to: 0)
    change_column_default(:reviews, :hidden, true)
    change_column_null(:reviews, :clicks, false, 0)
    change_column_null(:reviews, :rating, false, 0)
    change_column_null(:reviews, :description, false)
  end
end
