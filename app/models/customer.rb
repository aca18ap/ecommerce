# frozen_string_literal: true

# == Schema Information
#
# Table name: customers
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  suspended              :boolean          default(FALSE), not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  username               :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_customers_on_confirmation_token    (confirmation_token) UNIQUE
#  index_customers_on_email                 (email) UNIQUE
#  index_customers_on_reset_password_token  (reset_password_token) UNIQUE
#  index_customers_on_unlock_token          (unlock_token) UNIQUE
#  index_customers_on_username              (username) UNIQUE
#
class Customer < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  has_many :purchase_history
  has_many :products, -> { order('products.created_at DESC') }, through: :purchase_history
  has_many :affiliate_product_views

  devise :database_authenticatable, :registerable, :password_archivable, :recoverable,
         :rememberable, :secure_validatable, :lockable
end
