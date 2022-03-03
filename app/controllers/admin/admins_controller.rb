# frozen_string_literal: true

module Admin
  class AdminsController < StaffsController
    before_action :authorise_admin!

    private

    def authorise_admin!
      redirect_back fallback_location: root_path unless current_staff.admin?
    end
  end
end
