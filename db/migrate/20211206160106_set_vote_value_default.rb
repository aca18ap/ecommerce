class SetVoteValueDefault < ActiveRecord::Migration[6.1]
  def change 
    change_column_default :faq_votes, :value, from: 1, to: 0 
  end
end
