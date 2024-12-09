class PetitionStepsController < ApplicationController
  include Wicked::Wizard
  before_action :set_petition

  steps :basic_information, :petitioner_details, :petition_details, :additional_information, :consents, :confirmation

  def show
    render_wizard
  end

  def update
    @petition.current_step = step

    if params[:petition]
      @petition.assign_attributes(petition_params)
    end

    if @petition.save
      render_wizard @petition
    else
      render_wizard @petition
    end
  end

  def finish
    @petition.completed = true
    @petition.status = :draft

    if @petition.save
      redirect_to @petition, notice: 'Petycja została pomyślnie złożona.'
    else
      flash.now[:alert] = 'Wystąpił błąd podczas składania petycji.'
      render :confirmation
    end
  end


  def skip_step?(step)
    case step
    when :additional_information
      @petition.petition_type != 'third_party'
    else
      false
    end
  end

  private

  def set_petition
    @petition = Petition.find(params[:petition_id])
  end

  def petition_params
    params.require(:petition).permit(
      :petition_type,
      :title, :description, :justification, :tag_list, :external_links,
      :public_comment, :creator_name, :email,
      :residence_street, :residence_city, :residence_zip_code,
      :address_street, :address_city, :address_zip_code,
      :same_address,
      :third_party_street, :third_party_city, :third_party_zip_code,
      :recipient, :department_id,
      :gdpr_consent, :privacy_policy,
      attachments: [], # As an array
      images: [],       # As an array
      third_party_consents: []
      )
  end
end
