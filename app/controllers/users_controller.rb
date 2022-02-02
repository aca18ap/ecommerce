class UsersController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.create(user_params)
    redirect_to :back if @user.save
  end

  def show
    if user_signed_in?
      @user = User.find_by_id(params[:id])
    else
      redirect_to create_new_user
    end
  end

  def delete
    @user = User.find_by_id(params[:id])
    if @user
      @user.delete
      if current_user == @user
        redirect_to root_path
      else
        redirect_to(request.referer)
      end
    else
      redirect_to(request.referer)
    end
  end

  private

  def find_user
    @user = find_by_id(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end
