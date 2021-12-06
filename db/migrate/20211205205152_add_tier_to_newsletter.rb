class AddTierToNewsletter < ActiveRecord::Migration[6.1]
  def change
    add_column :newsletters, :tier, :string
  end
end
