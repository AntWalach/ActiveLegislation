# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    Rails.logger.info "Custom SessionsController#create was called"
    
    user = User.find_by(email: params[:user][:email])
    
    if user && user.valid_password?(params[:user][:password])
      Log.create(user: user, action: "Login", status: "Successful", ip_address: request.remote_ip, details: "IP: #{request.remote_ip}" )
      Rails.logger.info "User #{user.email} signed in successfully."
      sign_in(user)
      redirect_to after_sign_in_path_for(user)
    else
      # Failed login
      Log.create(user: user, action: "Login", status: "Failed", ip_address: request.remote_ip, details: "Email: #{params[:user][:email]}, IP: #{request.remote_ip}")
      Rails.logger.info "Login attempt failed for email #{params[:user][:email]}."
  

      redirect_to new_user_session_path, alert: "Invalid email or password."
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  
  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
