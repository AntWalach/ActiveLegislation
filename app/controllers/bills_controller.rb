class BillsController < ApplicationController
  load_and_authorize_resource
  before_action :set_bill, only: %i[ show edit update destroy ]

  # GET /bills or /bills.json
  # Wyświetla wszystkie inicjatywy ustawodawcze
  def index
    @bills = Bill.all
  end

  # GET /bills/1 or /bills/1.json
  # Wyświetla szczegóły konkretnej inicjatywy
  def show
    @bill_committee = @bill.bill_committee

    # Sprawdzenie, czy liczba zebranych podpisów spełnia wymagania
    if @bill_committee && @bill_committee.committee_signatures.count < Bill::MIN_SIGNATURES_FOR_REVIEW
      # Przekierowanie do widoku komitetu, jeśli podpisy nie zostały zebrane
      redirect_to bill_bill_committee_path(@bill), alert: "Liczba podpisów nie jest jeszcze wystarczająca."
    else
      # Logika wyświetlania ustawy, jeśli podpisy zostały zebrane
      render :show
    end
  end

  # GET /bills/new
  # Formularz tworzenia nowej inicjatywy ustawodawczej
  def new
    @bill = current_user.bills.new
    @bill.build_bill_committee
  end

  # POST /bills or /bills.json
  # Tworzy nową inicjatywę ustawodawczą i przypisuje komitet
  def create
    @bill = current_user.bills.new(bill_params)
    
    if @bill.save
      assign_committee_members(@bill.bill_committee)  # Przypisanie członków komitetu po utworzeniu inicjatywy

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
  # Aktualizuje szczegóły inicjatywy ustawodawczej i przypisuje komitet
  def update
    if @bill.update(bill_params)
      assign_committee_members(@bill.bill_committee)  # Aktualizacja członków komitetu

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

  private

  # Przypisanie członków komitetu inicjatywnego na podstawie dostarczonych emaili
  def assign_committee_members(committee)
    committee_emails = bill_params[:bill_committee_attributes].to_h.select { |k, v| k.include?("email") && v.present? }
    committee_emails.each_with_index do |(email_key, email), index|
      user = User.find_by(email: email)
      if user
        case index
        when 0 then committee.update(chairman_id: user.id)
        when 1 then committee.update(vice_chairman_id: user.id)
        else committee.members.create(user_id: user.id)
        end
        create_notification(user, "Zostałeś dodany do komitetu inicjatywnego ustawy: #{@bill.title}")
      end
    end
  end

  # Powiadamia użytkownika o dodaniu do komitetu
  def create_notification(user, message)
    Notification.create(user: user, message: message)
  end
  
  # Inicjalizacja obiektu ustawy na podstawie ID
  def set_bill
    @bill = Bill.find(params[:id])
  end

  # Silna kontrola parametrów dla inicjatywy ustawodawczej
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
        :member_email_1, :member_email_2, :member_email_3, 
        :member_email_4, :member_email_5, :member_email_6,
        :member_email_7, :member_email_8, :member_email_9, 
        :member_email_10, :member_email_11, :member_email_12, 
        :member_email_13
      ]
    )
  end
end
