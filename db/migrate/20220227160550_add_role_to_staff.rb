class AddRoleToStaff < ActiveRecord::Migration[6.1]
  def change
    add_column :staffs, :role, :integer, default: 1
  end
end
