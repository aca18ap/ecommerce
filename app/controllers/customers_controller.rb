# frozen_string_literal: true

class CustomersController < ApplicationController
  before_action :authenticate_staff!, only: :unlock
  before_action :authenticate_customer!, except: :unlock
  before_action :set_customer, only: %i[show edit update destroy unlock]

  def create; end

  def new; end

  # GET /customer/1
  def show
    redirect_back fallback_location: '/' unless customer_signed_in?
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
end
