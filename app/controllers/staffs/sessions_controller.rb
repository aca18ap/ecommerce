# frozen_string_literal: true

class Staffs::SessionsController < Devise::SessionsController
  include Accessible
  skip_before_action :check_user, only: :destroy
end
