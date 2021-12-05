class RemoveCLicksFromReviews < ActiveRecord::Migration[6.1]
  def change
    remove_column :reviews, :clicks, :integer
  end
end
