# frozen_string_literal: true

# Overridden devise controller to manage sessions functionality for businesses
class Businesses::SessionsController < Devise::SessionsController
  include Accessible
  skip_before_action :check_user, only: :destroy
end
