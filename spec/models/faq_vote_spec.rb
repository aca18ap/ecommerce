# == Schema Information
#
# Table name: faq_votes
#
#  id         :bigint           not null, primary key
#  ipAddress  :string
#  value      :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  faq_id     :bigint           not null
#
# Indexes
#
#  index_faq_votes_on_faq_id                (faq_id)
#  index_faq_votes_on_ipAddress_and_faq_id  (ipAddress,faq_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (faq_id => faqs.id)
#
require 'rails_helper'

RSpec.describe FaqVote, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
