class Admin::UsersController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource

    def new
        @user = user_type_class.new
    end

    def create
        @user = user_type_class.new(user_params)
        if @user.save
            redirect_to users_path, notice: "#{@user.type} został pomyślnie utworzony."
        else
            render :new, status: :unprocessable_entity
        end
    end

    private

        def user_type_class
            case params.dig(:user, :type)
            when "StandardUser" then StandardUser
            when "Admin" then Admin
            when "Official" then Official
            else User
            end
        end

        def user_params
            params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :password, :password_confirmation, :type)
        end
end

  