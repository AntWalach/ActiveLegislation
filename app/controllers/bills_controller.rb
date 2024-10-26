class BillsController < ApplicationController
  load_and_authorize_resource
  before_action :set_bill, only: %i[ show edit update destroy ]

  # GET /bills or /bills.json
  def index
    @bills = Bill.all
  end

  # GET /bills/1 or /bills/1.json
  def show
    @bill_committee = @bill.bill_committee

    # Sprawdzenie, czy liczba zebranych podpisów spełnia wymagania
    if @bill_committee && @bill_committee.committee_signatures.count < 1
      # Przekierowanie do widoku komitetu, jeśli podpisy nie zostały zebrane
      redirect_to bill_bill_committee_path(@bill)
    else
      # Logika wyświetlania ustawy, jeśli podpisy zostały zebrane
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
    
    if @bill.save
      assign_committee_members(@bill.bill_committee)  # Po zapisaniu bill wywołujemy metodę dla przypisania członków komitetu

      respond_to do |format|
        format.html { redirect_to bill_url(@bill), notice: "Bill was successfully created." }
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
      assign_committee_members(@bill.bill_committee)  # Aktualizacja członków komitetu przy aktualizacji bill

      respond_to do |format|
        format.html { redirect_to bill_url(@bill), notice: "Bill was successfully updated." }
        format.json { render :show, status: :ok, location: @bill }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /bills/1 or /bills/1.json
  def destroy
    @bill.destroy!
    redirect_to bills_url, notice: "Bill was successfully destroyed."
  end

  private

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

  def create_notification(user, message)
    Notification.create(user: user, message: message)
  end
  
  # Use callbacks to share common setup or constraints between actions.
  def set_bill
    @bill = Bill.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def bill_params
    params.require(:bill).permit(:title, :content, :justification, :category, :required_signatures, :signatures_deadline, :status, 
      bill_committee_attributes: [:chairman_email, :vice_chairman_email, :member_email_1, :member_email_2, :member_email_3, :member_email_4, 
                                  :member_email_5, :member_email_6, :member_email_7, :member_email_8, :member_email_9, :member_email_10, 
                                  :member_email_11, :member_email_12, :member_email_13])
  end
end
