class UsersController < ApplicationController
  before_action :authenticate_user!


  def new
  end


  def create    
    @user = User.create(user_params)

    if @user.save
      redirect_to(request.referer)
    else
      redirect_to root_path
    end

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
      if current_user == @user
        @user.delete
        redirect_to root_path
      else
        @user.delete
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
      params.require(:user).permit(:email, :password, :password_confirmation, :role)
    end

    

end
