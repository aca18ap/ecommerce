class AddDefaultValuesToFaQs < ActiveRecord::Migration[6.1]
  def change
    change_column_default(:faqs, :clicks, from: nil, to: 0)
    change_column_default(:faqs, :usefulness, from: nil, to: 0)
    change_column_null(:faqs, :clicks, false, 0)
    change_column_null(:faqs, :usefulness, false, 0)
    change_column_null(:faqs, :question, false, "Empty Question")
  end
end
