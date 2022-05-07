# frozen_string_literal: true

# Overridden devise controller to manage registration functionality for customers
class Customers::RegistrationsController < Devise::RegistrationsController
  include Accessible
  skip_before_action :check_user, except: %i[new create]
  before_action :configure_sign_up_params, only: :create
  before_action :configure_account_update_params, only: :update

  # GET /resource/sign_up

  # POST /resource
  def create
    super
    return unless resource.save

    location = RetrieveLocation.new(nil, request.remote_ip).location
    Sentry.capture_message("IP: #{request.remote_ip}\nLatitude: #{location[:laitude]}\nLongitude: #{location[:longitude]}")
    Registration.create(latitude: location[:latitude], longitude: location[:longitude],
                        vocation: Registration.vocations[:customer])
  end

  # GET /resource/edit

  # PUT /resource

  # DELETE /resource

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[attribute username])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: %i[attribute username])
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
