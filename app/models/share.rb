# == Schema Information
#
# Table name: shares
#
#  id         :bigint           not null, primary key
#  count      :integer
#  social     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Share < ApplicationRecord
end
