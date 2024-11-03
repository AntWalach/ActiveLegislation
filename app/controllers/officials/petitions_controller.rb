class Officials::PetitionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_official!
  before_action :set_petition, only: %i[ show approve reject verify_signatures respond ]

  def index
    @search = Petition.all.ransack(params[:q])
    @petitions = @search.result(distinct: true).page(params[:page])
  end

  def show
  end

  # Zatwierdzenie petycji przez weryfikatora wstępnego
  def approve
    if current_user.official_role == 'initial_verifier' && @petition.submitted?
      if @petition.update(status: :under_review)
        NotificationsController.notify_approval(@petition.user, @petition)
        redirect_to officials_petitions_path, notice: "Petycja została zatwierdzona do przeglądu."
      else
        redirect_to officials_petitions_path, alert: "Nie udało się zatwierdzić petycji."
      end
    else
      redirect_to officials_petitions_path, alert: "Brak uprawnień do zatwierdzenia."
    end
  end

  # Odrzucenie petycji na dowolnym etapie
  def reject
    if @petition.update(status: :rejected, comments: params[:comments])
      NotificationsController.notify_rejection(@petition.user, @petition, params[:comments])
      redirect_to officials_petitions_path, notice: "Petycja została odrzucona."
    else
      redirect_to officials_petitions_path, alert: "Nie udało się odrzucić petycji."
    end
  end

  # Weryfikacja podpisów przez urzędnika ds. kompletności głosów
# In officials/petitions_controller.rb
  def verify_signatures
    Rails.logger.debug "Current User Role: #{current_user.official_role}"
    Rails.logger.debug "Petition Status: #{@petition.status}"
    Rails.logger.debug "Petition Signatures Required: #{@petition.requires_signatures?}"
    Rails.logger.debug "Petition Ready for Review: #{@petition.ready_for_review?}"

    if current_user.official_role == 'signature_verifier' && @petition.collecting_signatures? && @petition.ready_for_review?
      if @petition.update(status: :awaiting_response)
        #create_notification(@petition.user, "Podpisy pod Twoją petycją zostały zweryfikowane.")
        NotificationsController.notify_signature_verification(@petition.user, @petition)
        redirect_to officials_petitions_path, notice: "Podpisy zostały zweryfikowane."
      else
        Rails.logger.debug "Update failed: #{@petition.errors.full_messages.join(', ')}"
        redirect_to officials_petitions_path, alert: "Nie udało się zweryfikować podpisów."
      end
    else
      Rails.logger.debug "Verification conditions not met."
      redirect_to officials_petitions_path, alert: "Brak uprawnień lub niekompletna liczba podpisów."
    end
  end


  # Odpowiedź na petycję
  def respond
    if current_user.petition_handler? && @petition.awaiting_response?
      if @petition.update(status: :responded, comments: params[:comments])
        #create_notification(@petition.user, "Twoja petycja otrzymała odpowiedź. Komentarz: #{params[:comments]}")
        NotificationsController.notify_response(@petition.user, @petition, params[:comments])
        redirect_to officials_petitions_path, notice: "Petycja otrzymała odpowiedź."
      else
        redirect_to officials_petitions_path, alert: "Nie udało się dodać odpowiedzi do petycji."
      end
    else
      redirect_to officials_petitions_path, alert: "Brak uprawnień do odpowiedzi na petycję."
    end
  end

  private

  def set_petition
    @petition = Petition.find(params[:id])
  end

  def authenticate_official!
    redirect_to root_path, alert: 'Brak dostępu' unless current_user.is_a?(Official)
  end
end
