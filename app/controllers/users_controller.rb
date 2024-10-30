class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @search_url = users_path
    
    if params[:type].present?
      @search = User.where(type: params[:type]).ransack(params[:q])
    else
      @search = User.all.ransack(params[:q])
    end

    @list = @users = @search.result(distinct: true).page(params[:page])
    
    respond_to do |f|
      f.html
      f.js { render "application/index" }
    end
  end

  def edit
    set_user
  end

  def update
    set_user
    # Autoryzacja, jeśli admin lub aktualizowane są admin-polityki
    authorize! :update_admin_fields, User if check_admin_params
  
    # Sprawdzenie, czy użytkownik aktualizuje własne dane
    self_update = current_user == @user
  
    respond_to do |format|
      # Logika dla aktualizacji hasła (jeśli jest podane, użyj normalnego update, jeśli nie, użyj update_without_password)
      if user_params[:password].present?
        success = @user.update(user_params)
      else
        success = @user.update_without_password(user_params)
      end
  
      if success
        # Zaloguj użytkownika ponownie, jeśli aktualizował swoje dane
        sign_in(@user, bypass: true) if self_update
        flash[:notice] = "Użytkownik został zaktualizowany."
        
        # Odpowiedź zależna od formatu (turbo_stream lub html)
        format.turbo_stream { render turbo_stream: turbo_stream.replace("flash_message", partial: "application/flash") }
        format.html { redirect_to (self_update ? user_path(@user) : users_path), notice: "Użytkownik został zaktualizowany." }
      else
        # Jeśli aktualizacja się nie powiedzie, zwróć widok edycji z błędami
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end
  

  def dashboard
    @user = current_user
  end



  private


  def check_admin_params

    user_type_key = params[@user.class.name.underscore.to_sym]
  
    if user_type_key
      permitted_params = user_type_key.permit(:type).to_h
      permitted_params.any? { |key, value| value.present? }
    else
      false
    end
  end

  def set_user
    @user = User.find(params[:id])
  end


  
  # def user_params
  #   permitted = [:email, :phone_number, :password, :password_confirmation, :first_name, :last_name, :address, :postal_code, :city, :country, :pesel, :date_of_birth, :verified, :public_key]
  
  #   # Dodatkowe pola dla urzędników
  #   permitted += [:department, :office_location] if @user.is_a?(Official)
  #   permitted += [:type] if @user.is_a?(Admin)
  #   params.require(@user.class.name.underscore.to_sym).permit(permitted)
  # end

  def user_params

    permitted = [
      :first_name, :last_name, :email, :address, :postal_code, :city, :country,
      :pesel, :phone_number, :date_of_birth, :password, :password_confirmation,
      :verified, :public_key, :type
    ]
  
    permitted += [:department, :office_location] if params[:official]
  
    if params[:admin]
      params.require(:admin).permit(permitted)
    elsif params[:official]
      params.require(:official).permit(permitted)
    else
      params.require(:standard_user).permit(permitted)
    end
  end

  # def user_params
  #   permitted = [
  #     :first_name, :last_name, :email, :address, :postal_code, :city, :country,
  #     :pesel, :phone_number, :date_of_birth, :password, :password_confirmation,
  #     :verified, :type
  #   ]
  #   permitted += [:department, :office_location] if params[:official]
  #   params.require(user_type_class.to_s.underscore.to_sym).permit(permitted)
  # end

end