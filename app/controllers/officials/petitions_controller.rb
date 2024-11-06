class Officials::PetitionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_official!
  before_action :set_petition, only: %i[ show approve reject verify_signatures respond request_supplement forward_for_response ]

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

  def merge_petitions
    primary_petition = Petition.find(params[:primary_petition_id])
    petitions_to_merge = Petition.where(id: params[:petition_ids])

    petitions_to_merge.update_all(grouped_petition_id: primary_petition.id)

    # Aktualizacja statusu petycji
    primary_petition.update(status: :under_review)

    redirect_to officials_petitions_path, notice: "Petycje zostały połączone do wspólnego rozpatrzenia."
  end

  def leave_unconsidered
    if @petition.update(status: :unconsidered, comments: params[:comments])
      NotificationsController.notify_unconsidered(@petition.user, @petition, params[:comments])
      redirect_to officials_petitions_path, notice: "Petycja została pozostawiona bez rozpatrzenia."
    else
      redirect_to officials_petitions_path, alert: "Nie udało się zmienić statusu petycji."
    end
  end

  def request_supplement
    if @petition.update(status: :supplement_required, comments: params[:comments])
      NotificationsController.notify_supplement_required(@petition.user, @petition, params[:comments])
      redirect_to officials_petitions_path, notice: "Wysłano wezwanie do uzupełnienia petycji."
    else
      redirect_to officials_petitions_path, alert: "Nie udało się wysłać wezwania."
    end
  end


  def forward_for_response
    if current_user.official_role == 'petition_verifier' && @petition.under_review?
      if @petition.update(status: :awaiting_response)
        NotificationsController.notify_forwarded(@petition.user, @petition)
        redirect_to officials_petitions_path, notice: "Petycja została przekazana do rozpatrzenia."
      else
        redirect_to officials_petitions_path, alert: "Nie udało się przekazać petycji."
      end
    else
      redirect_to officials_petitions_path, alert: "Brak uprawnień do wykonania tej akcji."
    end
  end

  private

  def set_petition
    @petition = Petition.find(params[:id])
  end

end
