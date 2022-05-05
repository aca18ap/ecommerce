# frozen_string_literal: true

# Customer controller for managing customer only actions
class CustomersController < ApplicationController
  before_action :authenticate_staff!, only: :unlock
  before_action :authenticate_customer!, except: :unlock
  before_action :set_customer, except: %i[create new]

  # GET /customer
  def index
    redirect_back fallback_location: root_path
  end

  def create; end

  def new; end

  # GET /customer/1
  def show
    # Sets customer if using authenticated customer root
    @customer = Customer.includes(:products).find(current_customer.id) if @customer.nil?
    @customer = @customer.decorate

    send_gon_variables
  end

  # GET /customer/1/edit
  def edit; end

  # PATCH/PUT /customer/1
  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: 'Your details were successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /customer/1
  def destroy
    if @customer
      @customer.destroy

      if current_customer == @customer
        redirect_to root_path
      else
        redirect_back fallback_location: root_path
      end
    else
      redirect_to request.referer
    end
  end

  # PATCH /customer/1/unlock
  def unlock
    @customer.unlock_access!
    redirect_back fallback_location: root_path
  end

  private

  def set_customer
    @customer = Customer.find_by_id(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:email, :password, :password_confirmation, :username)
  end

  def send_gon_variables
    gon.timeCO2PerPurchase = CustomerMetrics.time_co2_per_purchase(@customer)
    gon.timeTotalCO2 = CustomerMetrics.time_total_co2(@customer)
    gon.timeCO2Saved = CustomerMetrics.time_co2_saved(@customer)
    gon.timeCO2PerPound = CustomerMetrics.time_co2_per_pound(@customer)
    gon.timeProductsTotal = CustomerMetrics.time_products_total(@customer)
  end
end
