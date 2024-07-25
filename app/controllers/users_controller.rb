class UsersController < ApplicationController
    load_and_authorize_resource

    def index
      @users = User.all
    end


    def dashboard
      @user = current_user
    end
    
end