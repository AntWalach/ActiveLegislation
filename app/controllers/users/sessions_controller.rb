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

    super do |resource|
      if resource.persisted?
      else
        Rails.logger.info "Problem with generating or setting the private key."
      end
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
