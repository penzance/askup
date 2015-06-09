class ApplicationController < ActionController::Base
  include ApplicationHelper

  # this is the base question group that will have no parent ID
  # and which is the final ancestor for all other question groups
  # note: this will have to match the base QuestionGroup ID in Question Market
  ROOT_QUESTION_GROUP_ID = 1

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

  rescue_from CanCan::AccessDenied do |exception|
    if user_signed_in?
      redirect_to root_path, alert: exception.message
    else
      redirect_to new_user_session_path , alert: "Please sign up to access this page."
    end
  end

end


