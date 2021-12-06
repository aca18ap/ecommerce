# == Schema Information
#
# Table name: visits
#
#  id                 :bigint           not null, primary key
#  csrf_token         :string
#  from               :datetime
#  latitude           :float
#  longitude          :float
#  path               :string
#  session_identifier :string
#  to                 :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :integer
#
class Visit < ApplicationRecord
end
