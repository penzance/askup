class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def analyzer
    if !defined?(@@analytics_logger)
      @@analytics_logger = Logger.new(Rails.configuration.askup.analytics.log_file)
      # set logger to level of info
      @@analytics_logger.level = Logger::INFO 
    end

    @@analytics_logger
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :first_name << :last_name
  end

  rescue_from CanCan::AccessDenied do |exception|
    if user_signed_in?
      redirect_to root_path, alert: exception.message
    else
      redirect_to new_user_session_path , alert: "Please sign up to access this page."
    end
  end

end


