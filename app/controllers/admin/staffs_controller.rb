# frozen_string_literal: true

# Manages the admin functionality for staff members such as inviting, updating, unlocking and deleting
class Admin::StaffsController < Admin::AdminsController
  protect_from_forgery with: :null_session
  before_action :set_staff, only: %i[edit update destroy not_current_staff]
  before_action :not_current_staff

  # GET /admin/staff/1/edit
  def edit; end

  # PATCH/PUT /admin/staff/1
  def update
    if @staff.update(staff_params)
      redirect_to admin_users_path, alert: 'Staff successfully updated'
    else
      redirect_to edit_admin_staff_path, alert: @staff.errors.full_messages.first
    end
  end

  # DELETE /admin/staff/1
  def destroy
    if @staff.destroy
      redirect_to admin_users_path, notice: 'Staff deleted'
    else
      redirect_to edit_admin_staff_path, alert: @staff.errors.full_messages.first
    end
  end

  private

  # Prevents admin from modifying their own account from this controller
  def not_current_staff
    redirect_back fallback_location: authenticated_admin_root_path if current_staff == @staff
  end

  def set_staff
    @staff = Staff.find_by_id(params[:id])
  end

  def staff_params
    params.require(:staff).permit(:email, :role)
  end
end
