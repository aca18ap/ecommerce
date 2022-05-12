# frozen_string_literal: true

# Decorator class for review view logic
class ReviewDecorator < Draper::Decorator
  delegate_all

  def truncated_description
    return if description.nil? || description.empty?

    description.truncate(120, separator: /\w+/)
  end
end
