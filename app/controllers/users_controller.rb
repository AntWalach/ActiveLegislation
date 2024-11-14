class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @search_url = users_path
    @search = params[:type].present? ? User.where(type: params[:type]).ransack(params[:q]) : User.all.ransack(params[:q])
    @list = @users = @search.result(distinct: true).page(params[:page])

    respond_to do |f|
      f.html
      f.js { render "application/index" }
    end
  end

  # GET /users/admins - Lists only admin users
  def index_admins
    @search_url = index_admins_users_path
    @search = Admin.ransack(params[:q])
    @list = @admins = @search.result(distinct: true).page(params[:page])

    render :index_admins
  end

  # GET /users/officials - Lists only official users
  def index_officials
    @search_url = index_officials_users_path
    @search = Official.ransack(params[:q])
    @list = @officials = @search.result(distinct: true).page(params[:page])

    render :index_officials
  end


  def new
    @user = StandardUser.new
    @user_type = :standard
  end

  def new_official
    @user = Official.new
    @user_type = :official
  end

  def new_admin
    @user = Admin.new
    @user_type = :admin
  end


  def create
    if params[:admin]
      @user = Admin.new(admin_params)
    elsif params[:official]
      @user = Official.new(official_params)
    else
      @user = StandardUser.new(standard_user_params)
    end
  
    respond_to do |format|
      if @user.save
        flash[:notice] = "User was successfully created."
        format.html { redirect_to users_path }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("flash_message", partial: "application/flash") }
      else
        format.html do
          render case @user
                 when Admin then :new_admin
                 when Official then :new_official
                 else :new
                 end
        end
        format.turbo_stream { render turbo_stream: turbo_stream.replace("flash_message", partial: "application/flash") }
      end
    end
  end

  def edit
    set_user
  end

  def update
    set_user
    authorize! :update_admin_fields, User if check_admin_params
  
    self_update = current_user == @user
  
    respond_to do |format|
      if user_params[:password].present?
        success = @user.update(user_params)
      else
        success = @user.update_without_password(user_params)
      end
  
      if success
        sign_in(@user, bypass: true) if self_update
        flash[:notice] = "Użytkownik został zaktualizowany."
        
        format.turbo_stream { render turbo_stream: turbo_stream.replace("flash_message", partial: "application/flash") }
        format.html { redirect_to (self_update ? user_path(@user) : users_path), notice: "Użytkownik został zaktualizowany." }
      else
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


  
  def user_params
    if params[:admin]
      admin_params
    elsif params[:official]
      official_params
    else
      standard_user_params
    end
  end
  
  private
  
    def admin_params
      params.require(:admin).permit(
        :first_name, :last_name, :email, :address, :postal_code, :city, :country,
        :pesel, :phone_number, :date_of_birth, :password, :password_confirmation,
        :type
      )
    end
    
    def official_params
      params.require(:official).permit(
        :first_name, :last_name, :email, :address, :postal_code, :city, :country,
        :pesel, :phone_number, :date_of_birth, :password, :password_confirmation,
        :type, :department, :office_location, :department_id, :official_role
      )
    end
    
    def standard_user_params
      params.require(:standard_user).permit(
        :first_name, :last_name, :email, :address, :postal_code, :city, :country,
        :pesel, :phone_number, :date_of_birth, :password, :password_confirmation,
        :type
      )
    end
  
end