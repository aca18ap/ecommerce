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
require 'rails_helper'

RSpec.describe Share, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
