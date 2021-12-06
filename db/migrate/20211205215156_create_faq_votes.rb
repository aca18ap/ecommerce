class CreateFaqVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :faq_votes do |t|
      t.string :ipAddress
      t.references :faq, null: false, foreign_key: true
      t.integer :value, null: false, :default => 1

      t.timestamps
    end
  end
end
