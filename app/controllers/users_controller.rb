class UsersController < ApplicationController
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected 

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.for(:sign_up) << :org_id
  # end

  load_and_authorize_resource
end
