class AddMoreUserTypesToProductReports < ActiveRecord::Migration[6.1]
  def change
    add_reference :product_reports, :business, foreign_key: true
    add_reference :product_reports, :staff, foreign_key: true
    change_column_null :product_reports, :customer_id, true
  end
end
