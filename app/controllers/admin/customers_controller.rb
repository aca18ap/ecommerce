# frozen_string_literal: true

module Admin
  class CustomersController < AdminsController
    protect_from_forgery with: :null_session
    before_action :set_customer, only: %i[edit update destroy]

    # GET /admin/customer/1/edit
    def edit; end

    # PATCH/PUT /admin/customer/1
    def update
      if @customer.update(customer_params)
        redirect_to admin_users_path, alert: 'Customer successfully updated'
      else
        redirect_to edit_admin_customer_path, alert: @customer.errors.full_messages.first
      end
    end

    # DELETE /admin/customer/1
    def destroy
      if @customer.destroy
        redirect_to admin_users_path, notice: 'Customer deleted'
      else
        redirect_to edit_admin_customer_path, alert: @customer.errors.full_messages.first
      end
    end

    private

    def set_customer
      @customer = Customer.find_by_id(params[:id])
    end

    def customer_params
      params.require(:customer).permit(:email, :username, :suspended)
    end
  end
end
