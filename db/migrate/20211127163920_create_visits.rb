class CreateVisits < ActiveRecord::Migration[6.1]
  def change
    create_table :visits do |t|
      t.datetime :from
      t.datetime :to
      t.string :csrf_token
      t.string :path
      t.integer :user_id
      t.string :session_identifier

      t.timestamps
    end
  end
end
