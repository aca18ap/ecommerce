# frozen_string_literal: true

# Helper for the application controller
module ApplicationHelper
  def additional_javascript(name)
    content_for :additional_javascript, "#{content_for?(:additional_javascript) ? ' ' : ''}#{name}"
  end
end
