# frozen_string_literal: true

# Decorator class for application
class ApplicationDecorator < Draper::Decorator
  def self.collection_decorator_class
    PaginatingDecorator
  end
end
