class BillCommitteesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bill_committee, only: [:show, :sign]

  def show
    @signatures = @bill_committee.committee_signatures
  end

  def sign
    @signature = @bill_committee.committee_signatures.new(user: current_user)

    if @signature.save
      flash[:notice] = "Poparłeś komitet."
    else
      flash[:alert] = "Nie udało się poprzeć komitetu."
    end

    redirect_to bill_bill_committee_path(@bill_committee.bill, @bill_committee)
  end

  private

  def set_bill_committee
    @bill = Bill.find_by(id: params[:bill_id])
    Rails.logger.debug "Params received: #{params.inspect}"
    Rails.logger.debug "Bill found: #{@bill.inspect}" if @bill
    @bill_committee = BillCommittee.find_by(bill_id: @bill.id)
    Rails.logger.debug "BillCommittee found: #{@bill_committee.inspect}" if @bill_committee
  
    unless @bill
      redirect_to bills_path, alert: "Ustawa nie istnieje." and return
    end
    unless @bill_committee
      redirect_to bills_path, alert: "Komitet dla tej ustawy nie istnieje." and return
    end
  end
end
