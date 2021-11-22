# == Schema Information
#
# Table name: faqs
#
#  id         :bigint           not null, primary key
#  answer     :text
#  clicks     :integer
#  hidden     :boolean
#  question   :text
#  usefulness :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Faq < ApplicationRecord
end
