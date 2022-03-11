# frozen_string_literal: true

# Overridden devise controller to manage invitations functionality for staff members
class Staffs::InvitationsController < Devise::InvitationsController
  before_action :configure_permitted_parameters

  def create
    self.resource = invite_resource
    redirect_to admin_users_path, alert: 'Invite sent successfully!' if resource.errors.empty?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:invite, keys: %i[email role])
  end
end
