# frozen_string_literal: true

module Admin
  class UsersController < AdminsController
    protect_from_forgery with: :null_session

    def index
      @staff = Staff.all.decorate
      @customers = Customer.all.decorate
      @businesses = Business.all.decorate
    end

  end
end
