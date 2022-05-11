# frozen_string_literal: true

# Decorator class for product report view logic
class ProductReportDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def user_link
    @staff = staff
    @business = business
    @customer = customer
    if object.staff_id
      h.link_to @staff.email, @staff
    elsif object.business_id
      h.link_to @business.name, @business
    else
      h.link_to @customer.username, @customer
    end
  end

  def product_link
    h.link_to product.name, product
  end
end
