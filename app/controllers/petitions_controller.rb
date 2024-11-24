class PetitionsController < ApplicationController
  load_and_authorize_resource
  before_action :set_petition, only: %i[ show edit update destroy submit ]
  before_action :authenticate_user!
  
  # GET /petitions or /petitions.json
  def index
    @search = Petition.where(status: :responded).ransack(params[:q])
    @petitions = @search.result(distinct: true).page(params[:page])
    @my_petitions = current_user.petitions.completed.page(params[:my_page])
  end
  

  # GET /petitions/1 or /petitions/1.json
  def show
    @petition.increment!(:views)

    unless PetitionView.exists?(petition: @petition, ip_address: request.remote_ip)
      PetitionView.create!(petition: @petition, user: current_user, ip_address: request.remote_ip)
    end
  end

  # GET /petitions/new
  def new
    @petition = Petition.new(user: current_user)

    if @petition.save(validate: false)
      redirect_to petition_petition_step_path(@petition, :basic_information)
    else
      flash[:alert] = 'Nie udało się rozpocząć tworzenia petycji.'
      redirect_to authenticated_root_path
    end
  end

  # POST /petitions or /petitions.json
  def create
    @petition = Petition.new(petition_params)
    @petition.user = current_user if user_signed_in?
    @petition.status = "draft"
    if @petition.save
      redirect_to petition_petition_steps_path(@petition)
    else
      render :new
    end
  end

  def submit
    if @petition.draft? && @petition.update(status: :submitted)
      Notification.notify_submission(@petition.user, @petition)
      # Wysyłanie potwierdzenia
      Notification.send_acknowledgment(@petition.user, @petition)
      redirect_to petition_url(@petition), notice: "Petycja została zgłoszona do weryfikacji."
    else
      redirect_to petition_url(@petition), alert: "Nie udało się zgłosić petycji."
    end
  end


  def edit
    if @petition.user == current_user && (@petition.draft? || @petition.awaiting_supplement?)
      # Allow editing
    else
      redirect_to @petition, alert: "Nie masz uprawnień do edycji tej petycji."
    end
  end
  

  # PATCH/PUT /petitions/1 or /petitions/1.json
  def update
    respond_to do |format|
      if @petition.update(petition_params)
        if @petition.awaiting_supplement?
          @petition.update(status: :submitted)

        end
        format.html { redirect_to petition_url(@petition), notice: "Petycja została zaktualizowana." }
        format.json { render :show, status: :ok, location: @petition }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @petition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /petitions/1 or /petitions/1.json
  def destroy
    @petition.destroy!
    respond_to do |format|
      format.html { redirect_to petitions_url, notice: "Petycja została usunięta." }
      format.json { head :no_content }
    end
  end

  def publish
    if @petition.update(published: true)
      redirect_to @petition, notice: "Petycja została opublikowana."
    else
      redirect_to @petition, alert: "Nie udało się opublikować petycji."
    end
  end

  private


  def set_petition
    @petition = Petition.find(params[:id])
  end

  def petition_params
    params.require(:petition).permit(
      :title, :description, :justification, :tag_list, :external_links,
      :attachments, :main_image, :images, :public_comment,
      :creator_name, :email,
      # Pola adresu zamieszkania lub siedziby
      :residence_street, :residence_city, :residence_zip_code,
      # Pola adresu do korespondencji
      :address_street, :address_city, :address_zip_code,
      # Checkbox same_address
      :same_address,
      # Pola dla petycji osób trzecich
      :petition_type, :third_party_name,
      :third_party_street, :third_party_city, :third_party_zip_code,
      :recipient, :department_id,
      # Zgody
      :gdpr_consent, :privacy_policy, third_party_consents: []
    )
  end
end
