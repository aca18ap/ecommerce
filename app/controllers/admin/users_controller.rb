class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin
  protect_from_forgery with: :null_session


  def index
    @users = User.all
  end

  def destroy
    @user = User.find_by_id(params[:id])
    puts(@user)
    if @user.destroy
      redirect_to admin_users_path, notice: 'User deleted'
    else
      render action: 'index'
      flash[:error] = "User couldn't be deleted"
    end
  end

  def create
    if User.exists?(params[:email])
      redirect_to admin_users_path, alert: "User already exists"
    else
      User.invite!(email: params[:email])
    end
  end

  def edit
    @user = User.find(find_user)
    @user.role
  end

  private

  def authorize_admin
    if current_user.role != 'admin'
      redirect_to root_path, alert: 'Only admins can create accounts'
    else
      true
    end
  end

  def find_user
    @user = User.find_by_id(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :role)
  end
end
