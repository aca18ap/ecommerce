
class Admin::UserController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin


    def index
      @users = User.all()
    end

    def delete_user
      user = User.find_by_id(params[:id])
      user.delete
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to show_all_users
      else
      redirect_to show_all_users, alert: "Please fill all the fields to create an account"
      end
    end

    

    private 

    def authorize_admin
      if current_user.role != 'admin'
        redirect_to root_path, alert: "Only admins can create accounts"
      else
        return true
      end

      def user_params
        params.require(:user).permit(:id)
      end
    end


  end


