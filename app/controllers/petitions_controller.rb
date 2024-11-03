class PetitionsController < ApplicationController
  load_and_authorize_resource
  before_action :set_petition, only: %i[ show edit update destroy submit start_collecting_signatures ]
  before_action :authenticate_user!
  
  # GET /petitions or /petitions.json
  def index

    # Regular users see only petitions that are approved or actively collecting signatures
    @search = Petition.where(status: [:responded, :collecting_signatures]).ransack(params[:q])
    @petitions = @search.result(distinct: true).page(params[:page])

    # Each user's own petitions for any status
    @my_petitions = current_user.petitions.page(params[:my_page])
  end
  

  # GET /petitions/1 or /petitions/1.json
  def show
  end

  # GET /petitions/new
  def new
    @petition = current_user.petitions.new
  end

  # POST /petitions or /petitions.json
  def create
    @petition = current_user.petitions.new(petition_params)
    @petition.status = "draft"
    @petition.signature_goal ||= Petition::MIN_SIGNATURES_FOR_REVIEW if @petition.requires_signatures?

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

  # Akcja do zgłoszenia petycji do weryfikacji
  def submit
    if @petition.draft? && @petition.update(status: :submitted)
      NotificationsController.notify_submission(@petition.user, @petition)
      redirect_to petition_url(@petition), notice: "Petycja została zgłoszona do weryfikacji."
    else
      redirect_to petition_url(@petition), alert: "Nie udało się zgłosić petycji."
    end
  end

  # Akcja inicjująca zbieranie podpisów
  def start_collecting_signatures
    Rails.logger.debug "Current Petition Status: #{@petition.status}"
    Rails.logger.debug "Petition requires signatures? #{@petition.requires_signatures?}"
  
    # Allow the transition if the petition is in `under_review` and requires signatures
    if (@petition.submitted? || @petition.under_review?) && @petition.requires_signatures?
      if @petition.update(status: :collecting_signatures)
        NotificationsController.notify_collecting_signatures(@petition.user, @petition)
        redirect_to petition_url(@petition), notice: "Rozpoczęto zbieranie podpisów."
      else
        Rails.logger.debug "Update failed: #{@petition.errors.full_messages.join(', ')}"
        redirect_to petition_url(@petition), alert: "Nie udało się rozpocząć zbierania podpisów."
      end
    else
      Rails.logger.debug "Conditions not met: #{@petition.status} - Requires signatures: #{@petition.requires_signatures?}"
      redirect_to petition_url(@petition), alert: "Nie udało się rozpocząć zbierania podpisów."
    end
  end
  

  # PATCH/PUT /petitions/1 or /petitions/1.json
  def update
    respond_to do |format|
      if @petition.update(petition_params)
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

  private


  def set_petition
    @petition = Petition.find(params[:id])
  end

  def petition_params
    params.require(:petition).permit(:title, :description, :category, :subcategory, :address, :recipient, :justification, :signature_goal, :privacy_policy, :end_date, :public_comment, :attachment, :external_links, :priority, :comments, :gdpr_consent, :petition_type)
  end
end
