# frozen_string_literal: true

# Business controller for managing business only actions
class BusinessesController < ApplicationController
  # before_action :authenticate_customer!
  # before_action :authenticate_staff!, only: :unlock
  # before_action :authenticate_business!, except: :unlock
  before_action :set_business, only: %i[show edit update destroy unlock]
  load_and_authorize_resource

  # GET /businesses
  def index
    @businesses = Business.order('created_at DESC').all.decorate
  end

  # GET /businesses/1
  def show
 
  end

  # GET /businesses/1/edit
  def edit; end

  # DELETE /businesses/1
  def destroy
    if @business
      @business.destroy

      if current_business == @business
        redirect_to root_path
      else
        redirect_back fallback_location: root_path
      end
    else
      redirect_to request.referer
    end
  end

  # PATCH /businesses/1/unlock
  def unlock
    @business.unlock_access!
    redirect_back fallback_location: root_path
  end

  private

  def set_business
    @business = Business.find_by_id(params[:id])
    redirect_to businesses_path unless @business
  end

  def business_params
    params.require(:business).permit(:email, :password, :password_confirmation, :name, :description)
  end
end
