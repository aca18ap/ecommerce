class AddUniquenessConstraintToIpAddress < ActiveRecord::Migration[6.1]
  def change
    add_index(:faq_votes, [:ipAddress, :faq_id], unique: true)
  end
end
