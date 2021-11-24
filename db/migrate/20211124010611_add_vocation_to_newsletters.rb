class AddVocationToNewsletters < ActiveRecord::Migration[6.1]
  def change
    add_column :newsletters, :vocation, :string, default: "Customer", null: false
  end
end
