class UsersController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
  end

  def show
    @user = User.find_by_id(params[:id])
  end

end
