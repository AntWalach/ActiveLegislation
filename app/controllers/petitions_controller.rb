class PetitionsController < ApplicationController
  load_and_authorize_resource
  before_action :set_petition, only: %i[ show edit update destroy submit ]
  before_action :authenticate_user!
  
  # GET /petitions or /petitions.json
  def index

    @search = Petition.where(status: [:responded]).ransack(params[:q])
    @petitions = @search.result(distinct: true).page(params[:page])

    @my_petitions = current_user.petitions.page(params[:my_page])
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
    @petition = current_user.petitions.new
  end

  # POST /petitions or /petitions.json
  def create
    @petition = current_user.petitions.new(petition_params)
    @petition.status = "draft"

    respond_to do |format|
      if @petition.save
        format.html { redirect_to petition_url(@petition), notice: "Petycja została pomyślnie utworzona." }
        format.json { render :show, status: :created, location: @petition }
      else
        Rails.logger.debug "Validation errors: #{@petition.errors.full_messages.join(', ')}"
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @petition.errors, status: :unprocessable_entity }
      end
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
      :title, :description, :justification, :petition_type, :recipient, :department_id,
      :creator_name, :address, :email, :gdpr_consent, :privacy_policy,
      :third_party_name, :third_party_address, :third_party_consent,
      :category, :subcategory, :external_links, :end_date, :public_comment, :tag_list, :main_image, attachments: [], images: [],
      
    )
  end
end
