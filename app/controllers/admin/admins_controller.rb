# frozen_string_literal: true

# Admins Controller use to ensure that any child controller is only accessible to admins
class Admin::AdminsController < StaffsController
  before_action :authorise_admin!

  private

  def authorise_admin!
    redirect_back fallback_location: root_path unless current_staff.admin?
  end
end
