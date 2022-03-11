# frozen_string_literal: true

# Manages admin functionality for managing all user types
class Admin::UsersController < Admin::AdminsController
  protect_from_forgery with: :null_session

  def index
    @staff = Staff.all.decorate
    @customers = Customer.all.decorate
    @businesses = Business.all.decorate
  end
end
