# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    # Tworzymy nowego użytkownika typu StandardUser
    build_resource(sign_up_params.merge(type: "StandardUser"))

    # Próba zapisania użytkownika
    if resource.save
      flash[:notice] = "Rejestracja zakończona sukcesem. "

      if resource.active_for_authentication?
        
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end


  # def save_temp_data
  #   registration_data = sign_up_params
  #   Rails.logger.debug "Dane zapisane w sesji: #{registration_data.inspect}"
  
  #   if registration_data.values.any?(&:blank?)
  #     Rails.logger.debug "Nie wszystkie pola zostały wypełnione: #{registration_data.inspect}"
  #     render json: { error: "Wszystkie pola muszą być wypełnione." }, status: :unprocessable_entity
  #     return
  #   end
  
  #   session[:registration_data] = registration_data
  #   render json: { message: "Dane zapisane pomyślnie. Możesz teraz wygenerować dokument." }, status: :ok
  # end
  
  

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  private
    def sign_up_params
      params.require(:user).permit(
        :first_name, :last_name, :phone_number, :email, :province, :address, :postal_code, :city, :pesel,
        :password, :password_confirmation,
        :terms_of_service, :consent_data_processing, :information_acknowledgment, :verification_document
      )
    rescue ActionController::ParameterMissing
      {}
    end
  end
