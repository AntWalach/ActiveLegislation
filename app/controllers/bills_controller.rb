class BillsController < ApplicationController
  load_and_authorize_resource
  before_action :set_bill, only: %i[ initialize_committee_formation show edit update destroy]

  # GET /bills or /bills.json
  # def index
  #   @bills = Bill.all
  # end
  def index

    # Regular users see only petitions that are approved or actively collecting signatures
    @search = Bill.where(status: [:aproved, :collecting_signatures, :committee_formation]).ransack(params[:q])
    @bills = @search.result(distinct: true).page(params[:page])

    # Each user's own petitions for any status
    @my_bills = current_user.bills.page(params[:my_page])
  end
  

  # GET /bills/1 or /bills/1.json
  def show
    @bill_committee = @bill.bill_committee

    if @bill.committee_formation? && @bill_committee.committee_signatures.count < Bill::MIN_SIGNATURES_FOR_REVIEW
      redirect_to bill_bill_committee_path(@bill)
    else
      render :show
    end
  end

  # GET /bills/new
  def new
    @bill = current_user.bills.new
    @bill.build_bill_committee
  end

  # POST /bills or /bills.json
  def create
    @bill = current_user.bills.new(bill_params)
    @bill.status = "draft"
    if @bill.save
      assign_committee_members(@bill.bill_committee)

      respond_to do |format|
        format.html { redirect_to bill_url(@bill), notice: "Projekt ustawy został pomyślnie utworzony." }
        format.json { render :show, status: :created, location: @bill }
      end
    else
      Rails.logger.debug "Validation errors: #{@bill.errors.full_messages.join(', ')}"
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /bills/1 or /bills/1.json
  def update
    if @bill.update(bill_params)
      assign_committee_members(@bill.bill_committee)

      respond_to do |format|
        format.html { redirect_to bill_url(@bill), notice: "Projekt ustawy został pomyślnie zaktualizowany." }
        format.json { render :show, status: :ok, location: @bill }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /bills/1 or /bills/1.json
  # Usuwa inicjatywę ustawodawczą
  def destroy
    @bill.destroy!
    redirect_to bills_url, notice: "Projekt ustawy został pomyślnie usunięty."
  end


  def initialize_committee_formation
    if @bill.draft? 
      if @bill.update(status: :committee_formation)
        redirect_to bill_path(@bill), notice: "Status inicjatywy został zmieniony na 'Zbieranie podpisów dla komitetu'."
      else
        redirect_to bill_path(@bill), alert: "Nie udało się zmienić statusu inicjatywy."
      end
    else
      redirect_to bill_path(@bill), alert: "Inicjatywa nie spełnia warunków do zmiany statusu."
    end
  end

  private

    # Przypisanie członków komitetu inicjatywnego na podstawie dostarczonych emaili
    def assign_committee_members(committee)
      # Przypisz przewodniczącego
      if committee.chairman_email.present?
        user = User.find_by(email: committee.chairman_email)
        if user
          committee.committee_members.create(user: user, role: 'chairman')
          Rails.logger.debug "Chairman assigned: #{user.email}"
        else
          Rails.logger.debug "No user found for chairman email: #{committee.chairman_email}"
        end
      end
    
      # Przypisz wiceprzewodniczącego
      if committee.vice_chairman_email.present?
        user = User.find_by(email: committee.vice_chairman_email)
        if user
          committee.committee_members.create(user: user, role: 'vice_chairman')
          Rails.logger.debug "Vice Chairman assigned: #{user.email}"
        else
          Rails.logger.debug "No user found for vice chairman email: #{committee.vice_chairman_email}"
        end
      end
    
      # Przypisz pozostałych członków
      member_emails = committee.member_emails.to_s.split(',').map(&:strip).select(&:present?)
      member_emails.each do |email|
        user = User.find_by(email: email)
        if user
          committee.committee_members.create(user: user, role: 'member')
          Rails.logger.debug "Committee member assigned: #{user.email}"
        else
          Rails.logger.debug "No user found for committee member email: #{email}"
        end
      end
    end
    
    
    


  def create_notification(user, message)
    Notification.create(user: user, message: message)
  end

  def set_bill
    @bill = Bill.find(params[:id] || params[:bill_id])
  end

  def bill_params
    params.require(:bill).permit(
      :title, 
      :content, 
      :justification, 
      :category, 
      :signatures_deadline, 
      :status, 
      :current_state, 
      :proposed_changes, 
      :expected_effects, 
      :funding_sources, 
      :implementation_guidelines, 
      :eu_compliance, 
      :eu_remarks,
      :gdpr_consent, 
      :privacy_policy, 
      :public_disclosure_consent,
      attachments: [],
      bill_committee_attributes: [
        :chairman_email, 
        :vice_chairman_email, 
        :member_emails
      ]
    )
  end
  
end
