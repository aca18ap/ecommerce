# frozen_string_literal: true

# Decorator class for business view logic
class BusinessDecorator < Draper::Decorator
  delegate_all
  decorates_association :products

  def unlock_button?
    return unless access_locked?

    h.link_to 'Unlock', h.unlock_business_url(id),
              method: :patch, class: 'btn btn-xs',
              data: { confirm: 'Are you sure you want to unlock this account?' }
  end

  def truncated_description
    return if description.nil? || description.empty?

    description.truncate(50, separator: /\w+/)
  end

  def invite_button?
    # If an invitation has been sent and not accepted
    return unless invitation_accepted_at.nil? && !invitation_created_at.nil?

    h.link_to 'Resend', h.invite_business_url(id),
              method: :patch, class: 'btn btn-xs',
              data: { confirm: 'Resend invitation?' }
  end

  def total_product_views
    Product.joins(:affiliate_product_views).where(business_id: id).count
  end

  def customer_purchases
    Product.joins(:purchase_histories).where(business_id: id).count
  end

  def unique_product_categories
    Product.where(business_id: id).pluck(:category_id).uniq.count
  end
end
