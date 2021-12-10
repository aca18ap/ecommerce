class AddFeatureToShare < ActiveRecord::Migration[6.1]
  def change
    add_column :shares, :feature, :string
  end
end
