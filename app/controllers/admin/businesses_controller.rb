# frozen_string_literal: true

# Manages the admin functionality for businesses such as inviting, updating, unlocking and deleting
class Admin::BusinessesController < Admin::AdminsController
  protect_from_forgery with: :null_session
  before_action :set_business, only: %i[edit update destroy]

  # GET /admin/business/1/edit
  def edit; end

  # PATCH/PUT /admin/business/1
  def update
    if @business.update(business_params)
      redirect_to admin_users_path, alert: 'Business successfully updated'
    else
      redirect_to edit_admin_business_path, alert: @business.errors.full_messages.first
    end
  end

  # DELETE /admin/business/1
  def destroy
    if @business.destroy
      redirect_to admin_users_path, notice: 'Business deleted'
    else
      redirect_to edit_admin_business_path, alert: @business.errors.full_messages.first
    end
  end

  private

  def set_business
    @business = Business.find_by_id(params[:id])
  end

  def business_params
    params.require(:business).permit(:email, :name, :description)
  end
end
