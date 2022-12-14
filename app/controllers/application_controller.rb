# frozen_string_literal: true

# Main parent controller for the project from which all (indirectly) inherit
class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Ensure that CanCanCan is correctly configured
  # and authorising actions on each controller
  # check_authorization

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :update_headers_to_disable_caching
  before_action :ie_warning
  before_action :current_ability
  before_action :set_global_search_variable

  # Catch NotFound exceptions and handle them neatly, when URLs are mistyped or mislinked
  rescue_from ActiveRecord::RecordNotFound do
    render template: 'errors/error_404', status: 404
  end
  rescue_from CanCan::AccessDenied do
    render template: 'errors/error_403', status: 403
  end

  # IE over HTTPS will not download if browser caching is off, so allow browser caching when sending files
  def send_file(file, opts = {})
    response.headers['Cache-Control'] = 'private, proxy-revalidate' # Still prevent proxy caching
    response.headers['Pragma'] = 'cache'
    response.headers['Expires'] = '0'
    super(file, opts)
  end

  protected

  # Allows staff to invite businesses using devise
  def authenticate_inviter!
    redirect_back fallback_location: root_path unless current_staff&.admin?
  end

  private

  def update_headers_to_disable_caching
    response.headers['Cache-Control'] = 'no-cache, no-cache="set-cookie", no-store, private, proxy-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '-1'
  end

  def ie_warning
    return unless request.user_agent.to_s =~ /MSIE [6-7]/ && request.user_agent.to_s !~ %r{Trident/7.0}

    redirect_to(ie_warning_path)
  end

  def after_sign_in_path_for(_resource)
    root_path
  end

  def current_ability
    @current_ability ||= if staff_signed_in?
                           Ability.new(current_staff)
                         elsif business_signed_in?
                           Ability.new(current_business)
                         else
                           customer_signed_in?
                           Ability.new(current_customer)
                         end
  end

  def set_global_search_variable
    @q = Product.joins(:category).ransack(params[:q])
  end

  def search
    index
    render :index
  end
end
