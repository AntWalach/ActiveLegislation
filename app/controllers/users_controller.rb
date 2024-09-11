class UsersController < ApplicationController
    load_and_authorize_resource

    def index
      @search_url = users_path
      @search = User.all.ransack(params[:q])
      @list = @users = @search.result(distinct: true).page(params[:page])
  
      respond_to do |f|
        f.html
        f.js {render "application/index"}
      end
    end


    def dashboard
      @user = current_user
    end

    def update
      self_update = current_user == @user
      authorize! :update_admin_fields, User if check_admin_params
      
      respond_to do |format|
        if user_params[:password].present? ? @user.update(user_params) : @user.update_without_password(user_params)
          sign_in(@user, bypass: true) if self_update
          flash[:notice] = "Użytkownik został zaktualizowany."
          format.turbo_stream {render turbo_stream: turbo_stream.replace("flash_message", partial: "application/flash")}
          format.html { redirect_to (@user == current_user ? user_path(@user) : users_path), notice: "Użytkownik został zaktualizowany." }
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    def generate_keys
      private_key = current_user.generate_keys!
      # Możesz wyświetlić klucz prywatny lub zapisać go w bezpiecznym miejscu
      render plain: private_key
    end
    

    def upload_public_key
      current_user.update(public_key: params[:public_key])
      render json: { message: 'Klucz publiczny został zapisany.' }, status: :ok
    end

    private

      def set_user
        @user = User.find(params[:id])
      end
  
      def check_admin_params
        [
            :roles, :owner,
        ].select{|a| !params[:user][a].blank?}.length > 0
     end
  
      def user_params
        params.require(:user).permit(:email, :phone, :password, :password_confirmation, :name, :avatar, :role_mask, :dkj, roles: [])
      end

end