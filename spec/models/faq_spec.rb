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
require 'rails_helper'

RSpec.describe Faq, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
