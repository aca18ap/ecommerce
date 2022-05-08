# frozen_string_literal: true

# Business controller for managing business only actions
class BusinessesController < ApplicationController
  before_action :set_business, only: %i[show edit update destroy unlock invite]
  load_and_authorize_resource except: :dashboard

  # GET /businesses/1
  def show; end

  # GET /businesses/dashboard
  def dashboard
    @business = Business.includes(products: [:image_attachment]).find(current_business.id)
    @business = @business.decorate
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

  # PATCH /businesses/1/invite
  def invite
    @business.invite!
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
