class PagesController < ApplicationController
  before_action :authenticate_user!, only: :show_users_list

  def home
    @current_nav_identifier = :home
  end



end
