# frozen_string_literal: true

module Admin
  class AdminsController < StaffsController
    before_action :authorise_admin!

    def index
      @staff = Staff.all.decorate
      @customers = Customer.all.decorate
      @businesses = Business.all.decorate
    end

    private

    def authorise_admin!
      redirect_back fallback_location: root_path unless current_staff.admin?
    end
  end
end
