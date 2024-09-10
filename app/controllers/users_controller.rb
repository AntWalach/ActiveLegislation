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

    def generate_keys
      private_key = current_user.generate_keys!
      # Możesz wyświetlić klucz prywatny lub zapisać go w bezpiecznym miejscu
      render plain: private_key
    end
    

    def upload_public_key
      current_user.update(public_key: params[:public_key])
      render json: { message: 'Klucz publiczny został zapisany.' }, status: :ok
    end
end