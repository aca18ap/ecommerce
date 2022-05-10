# frozen_string_literal: true

# Overridden devise controller to manage registration functionality for customers
class Customers::RegistrationsController < Devise::RegistrationsController
  include Accessible
  skip_before_action :check_user, except: %i[new create]
  before_action :configure_sign_up_params, only: :create
  before_action :configure_account_update_params, only: :update

  # POST /resource
  def create
    super
    return unless resource.save

    location = RetrieveLocation.new(nil, request.remote_ip).location
    Sentry.capture_message('#create' \
                           "\nIP: #{request.remote_ip}" \
                           "\nlocation: #{location}" \
                           "\nLatitude: #{location[:latitude]}" \
                           "\nLongitude: #{location[:longitude]}")
    Registration.create(latitude: location[:latitude], longitude: location[:longitude],
                        vocation: Registration.vocations[:customer])
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[attribute username])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: %i[attribute username])
  end
end
