# frozen_string_literal: true

# Decorator class for product view logic
class ProductDecorator < ApplicationDecorator
  delegate_all

  def business_name
    business ? business.name : 'Unknown'
  end

  def truncated_description
    return if description.nil? || description.empty?

    description.truncate(50, separator: /\w+/)
  end

  def co2_produced_with_unit
    "#{co2_produced}<sub>Kg</sub>".html_safe
  end

  def price_with_currency
    "£#{price}"
  end
end
