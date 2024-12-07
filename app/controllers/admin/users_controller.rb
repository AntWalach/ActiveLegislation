class Admin::UsersController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource

    def index
    end

    def unverified
      @search_url = departments_path
    
      @search = User.where(verified: false).ransack(params[:q])
      @list = @unverified_users = @search.result(distinct: true).page(params[:page])
      
      respond_to do |f|
        f.html
        f.js { render "application/index" }
      end
    end

    def show
    end    

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

    def edit
    end

    def update
        was_blocked = @user.blocked?
    
        if @user.update(user_params)
          # Sprawdź, czy status blokady się zmienił
          if @user.blocked? && !was_blocked
            UserMailer.account_blocked(@user).deliver_now
            Rails.logger.info "Admin #{current_user.id} zablokował użytkownika #{@user.id}."
          elsif !@user.blocked? && was_blocked
            UserMailer.account_unblocked(@user).deliver_now
            Rails.logger.info "Admin #{current_user.id} odblokował użytkownika #{@user.id}."
          end
    
          redirect_to admin_user_path(@user), notice: 'Użytkownik został zaktualizowany.'
        else
          render :edit
        end
    end

    def block
        if @user.is_a? Admin
          redirect_to admin_users_path, alert: 'Nie możesz zablokować administratora.'
          return
        end
    
        if @user.block!

          Rails.logger.info "Admin #{current_user.id} zablokował użytkownika #{@user.id}."
          redirect_to users_path, notice: 'Użytkownik został zablokowany.'
        else
          redirect_to users_path, alert: 'Nie udało się zablokować użytkownika.'
        end
      end
    
      # Akcja odblokowywania użytkownika
      def unblock
        if @user.is_a? Admin
          redirect_to users_path, alert: 'Nie możesz odblokować administratora.'
          return
        end
    
        if @user.unblock!

          Rails.logger.info "Admin #{current_user.id} odblokował użytkownika #{@user.id}."
          redirect_to users_path, notice: 'Użytkownik został odblokowany.'
        else
          redirect_to users_path, alert: 'Nie udało się odblokować użytkownika.'
        end
      end


    def verify
      user = User.find(params[:id])
      if user.update(verified: true)
        flash[:notice] = "Użytkownik został zweryfikowany."
      else
        flash[:alert] = "Nie udało się zweryfikować użytkownika."
      end
      redirect_to unverified_admin_users_path
    end
  
    def reject
      user = User.find(params[:id])
      if user.destroy # Możesz zmienić na `update(verified: false)` jeśli nie chcesz usuwać użytkownika
        flash[:notice] = "Użytkownik został odrzucony."
      else
        flash[:alert] = "Nie udało się odrzucić użytkownika."
      end
      redirect_to unverified_admin_users_path
    end
    
    

    private
    
    
        def set_user
            @user = User.find(params[:id])
        end
    
        def user_type_class
            case params.dig(:user, :type)
            when "StandardUser" then StandardUser
            when "Admin" then Admin
            when "Official" then Official
            else User
            end
        end

        def user_params
            params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :password, :password_confirmation, :blocked, :type)
        end
end

  