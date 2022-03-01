# frozen_string_literal: true

class BusinessesController < ApplicationController
  before_action :authenticate_staff!, only: :unlock
  before_action :set_business, only: %i[show edit update destroy unlock]

  # GET /businesses/1
  def show
    redirect_back fallback_location: root_path unless business_signed_in?
  end

  # GET /businesses/1/edit
  def edit; end

  # PATCH/PUT /businesses/1
  def update
    if @business.update(business_params)
      redirect_to @business, notice: 'Your details were successfully updated.'
    else
      render :edit
    end
  end

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
  end

  def business_params
    params.require(:business).permit(:email, :password, :password_confirmation, :name, :description)
  end
end
