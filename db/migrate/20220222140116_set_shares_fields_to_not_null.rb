class SetSharesFieldsToNotNull < ActiveRecord::Migration[6.1]
  def change
    change_column :shares, :feature, :string, null: false
    change_column :shares, :social, :string, null: false
  end
end
