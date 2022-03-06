# == Schema Information
#
# Table name: materials
#
#  id         :bigint           not null, primary key
#  co2_per_kg :float
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Material, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
