# frozen_string_literal: true

# Overridden devise controller to manage sessions functionality for staff members
class Staffs::SessionsController < Devise::SessionsController
  include Accessible
  skip_before_action :check_user, only: :destroy
end
