class SignaturesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_petition

  def create
    @signature = @petition.signatures.new(user: current_user, digital_signature: params[:signature])
    respond_to do |format|
      if @signature.verify_signature && @signature.save
        #render json: { message: 'Pomyślnie podpisano petycję.' }, status: :created
        flash[:notice] = 'Pomyślnie podpisano petycję.'
        format.json { render json: { notice: "Pomyślnie podpisano petycję.", signed: true }, status: :created }
      else
        format.html { redirect_to petition_url(@petition), status: :unprocessable_entity }
        format.json { render json: { errors: @signature.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end
  

  private

  def set_petition
    @petition = Petition.find(params[:petition_id])
  end
end
