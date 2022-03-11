# frozen_string_literal: true

# Errors controller handles http errors for the system
class ErrorsController < ApplicationController
  skip_before_action :ie_warning
  skip_before_action :verify_authenticity_token, only: [:error_422]
  skip_authorization_check

  def error_403; end

  def error_404; end

  def error_422; end

  def error_500
    render
  rescue StandardError
    render layout: 'plain_error'
  end

  def ie_warning; end
end
