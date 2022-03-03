# frozen_string_literal: true

module Admin
  class CustomersController < AdminsController
    protect_from_forgery with: :null_session

    def index
      @customers = Customer.all.decorate
    end

    def destroy
      @customer = Customer.find_by_id(params[:id])
      if @customer.destroy
        redirect_back fallback_location: admin_customer_path, notice: 'Customer deleted'
      else
        render action: 'index'
        flash[:error] = 'Customer couldn\'t be deleted'
      end
    end

    def create
      if Customer.exists?(params[:email])
        redirect_to admin_customer_path, alert: 'Customer already exists'
      else
        Customer.invite!(email: params[:email])
        redirect_to admin_customer_path
      end
    end

    def edit
      @customer = Customer.find_by_id(params[:id])
    end

    def update
      @customer = Customer.find_by_id(params[:id])
      if @customer.update(customer_params)
        @customers = Customer.all
        redirect_to admin_customer_path, alert: 'Role successfully updated'
      else
        redirect_to edit_admin_customer_path, alert: 'Check the customer\'s details again!'
      end
    end

    private

    def find_customer
      @customer = Customer.find_by_id(params[:id]).decorate
    end

    def customer_params
      params.require(:customer).permit(:email, :role)
    end
  end
end
