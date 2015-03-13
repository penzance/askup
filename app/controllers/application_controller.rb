class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_action :configure_permitted_parameters, if: :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def analyzer
    @@analytics_logger ||= Logger.new("#{Rails.root}" + ENV["analytics_log_file"])
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :first_name << :last_name
  end

end


