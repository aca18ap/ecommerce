class AddRoleToStaff < ActiveRecord::Migration[6.1]
  def change
    add_column :staffs, :role, :string, null: false, default:"reporter"
  end
end
