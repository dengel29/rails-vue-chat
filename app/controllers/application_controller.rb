class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected 
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in) do |user_params|
      user_params.permit(:username, :email, :password, :remember_me)
    end
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:username, :email, :password, :remember_me)
    end
  end

  def after_sign_in_path_for(resource)
    chats_path_url
  end

  def after_sign_up_path_for(scope)
    chats_path_url
  end
end
