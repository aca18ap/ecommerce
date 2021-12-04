class DropReviews < ActiveRecord::Migration[6.1]
  def change
    drop_table :reviews do |t|
      t.text "description", null: false
      t.integer "clicks", default: 0, null: false
      t.integer "usefulness", default: 0, null: false
      t.boolean "hidden", default: true
      t.integer "rank", default: 0
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
    end
  end
end
