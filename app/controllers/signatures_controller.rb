class SignaturesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_petition, only: [:petition_create]
  before_action :set_bill, only: [:bill_create]

  def petition_create
    @signature = @petition.signatures.new(user: current_user)
    
    respond_to do |format|
      if @signature.save
        format.html do
          flash[:notice] = 'Pomyślnie podpisano petycję.'
          redirect_to petition_path(@petition)
        end
        format.json { render json: { message: 'Pomyślnie podpisano petycję.' }, status: :created }
      else
        format.html do
          flash[:alert] = 'Nie udało się podpisać petycji.'
          redirect_to petition_path(@petition)
        end
        format.json { render json: @signature.errors, status: :unprocessable_entity }
      end
    end
  end

  def bill_create
    @signature = @bill.signatures.new(user: current_user)

    respond_to do |format|
      if @signature.save
        format.html do
          flash[:notice] = 'Pomyślnie podpisano projekt ustawy.'
          redirect_to bill_path(@bill)
        end
        format.json { render json: { message: 'Pomyślnie podpisano projekt ustawy.' }, status: :created }
      else
        format.html do
          flash[:alert] = 'Nie udało się podpisać projektu ustawy.'
          redirect_to bill_path(@bill)
        end
        format.json { render json: @signature.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_petition
    @petition = Petition.find(params[:petition_id])
  end

  def set_bill
    @bill = Bill.find(params[:bill_id])
  end
end
