# frozen_string_literal: true

class StaffsController < ApplicationController
  before_action :set_staff, only: %i[show edit update destroy]

  # GET /staffs/1
  def show
    redirect_back fallback_location: root_path unless staff_signed_in?
  end

  # GET /staffs/1/edit
  def edit; end

  # PATCH/PUT /staffs/1
  def update
    if @staff.update(staff_params)
      redirect_to @staff, notice: 'Your details were successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /staffs/1
  def destroy
    if @staff
      @staff.destroy

      if current_staff == @staff
        redirect_to root_path
      else
        redirect_back fallback_location: root_path
      end
    else
      redirect_to request.referer
    end
  end

  private

  def set_staff
    @staff = Staff.find_by_id(params[:id])
  end

  def staff_params
    params.require(:staff).permit(:email, :password, :password_confirmation)
  end
end
