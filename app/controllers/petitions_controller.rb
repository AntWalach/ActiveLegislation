class PetitionsController < ApplicationController
  load_and_authorize_resource
  before_action :set_petition, only: %i[ show edit update destroy submit ]
  before_action :authenticate_user!
  
  # GET /petitions or /petitions.json
  def index
    @search = Petition.where.not(status: :draft).ransack(params[:q])
    @petitions = @search.result(distinct: true).page(params[:page])
    @my_petitions = current_user.petitions.completed.page(params[:my_page])
  end

  def my_petitions
    @my_petitions = current_user.petitions.completed.page(params[:page])
  end
  

  # GET /petitions/1 or /petitions/1.json
  def show
    @petition.increment!(:views)
    @comments = @petition.comments.order(created_at: :desc)
    @official_comments = @petition.official_comments.includes(:official)
    unless PetitionView.exists?(petition: @petition, ip_address: request.remote_ip)
      PetitionView.create!(petition: @petition, user: current_user, ip_address: request.remote_ip)
    end
    qr_code = RQRCode::QRCode.new(request.original_url)

      # Generowanie SVG (lub PNG, jeśli chcesz)
    @qr_code_svg = qr_code.as_svg(
        offset: 0,
        color: "000",
        shape_rendering: "crispEdges",
        module_size: 6,
        standalone: true
    )

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
    @petition.status = :draft
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
    if (@petition.user == current_user && (@petition.draft? || @petition.awaiting_supplement?)) 
      # Allow editing
    elsif current_user.is_a? Admin

    else
      redirect_to @petition, alert: "Nie masz uprawnień do edycji tej petycji."
    end
  end
  

  # PATCH/PUT /petitions/1 or /petitions/1.json
  def update
    respond_to do |format|
      if update_petition_with_attachments
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

  def update_petition_with_attachments
    ActiveRecord::Base.transaction do
      Rails.logger.debug "Dodawanie załączników..."
      if petition_params[:attachments].present?
        @petition.attachments.attach(petition_params[:attachments])
      end
  
      Rails.logger.debug "Dodawanie zdjęć..."
      if petition_params[:images].present?
        @petition.images.attach(petition_params[:images])
      end
  
      Rails.logger.debug "Dodawanie głównego zdjęcia..."
      if petition_params[:main_image].present?
        @petition.main_image.attach(petition_params[:main_image])
      end
  
      Rails.logger.debug "Dodawanie zgód osób trzecich..."
      if petition_params[:third_party_consents].present?
        @petition.third_party_consents.attach(petition_params[:third_party_consents])
      end
  
      Rails.logger.debug "Aktualizacja pozostałych pól..."
      unless @petition.update!(petition_params.except(:attachments, :images, :main_image, :third_party_consents))
        raise ActiveRecord::Rollback, "Nie udało się zaktualizować petycji"
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Błąd podczas aktualizacji: #{e.message}"
    false
  end

  def set_petition
    @petition = Petition.find(params[:id])
  end

  def petition_params
    params.require(:petition).permit(
      :identifier,
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
      :submission_date, :response_deadline, 
      :business_name, :business_email, :representative_name,
      # Zgody
      :consent_to_publish, :gdpr_consent, :privacy_policy, third_party_consents: []
    )
  end
end
