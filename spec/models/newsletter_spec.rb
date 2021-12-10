# frozen_string_literal: true

# == Schema Information
#
# Table name: newsletters
#
#  id         :bigint           not null, primary key
#  email      :string
#  latitude   :float
#  longitude  :float
#  tier       :string
#  vocation   :string           default("Customer"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Newsletter, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
