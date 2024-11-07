class Officials::PetitionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_official!
  before_action :set_petition, only: %i[ show approve reject verify_signatures respond request_supplement forward_for_response add_comment ]

  def index
    @search = Petition.all.ransack(params[:q])
    @petitions = @search.result(distinct: true).page(params[:page])
  end

  def show
    @comments = @petition.petition_comments.includes(:official).order(created_at: :asc)
    @comment = PetitionComment.new
  end

  # Zatwierdzenie petycji przez weryfikatora wstępnego
  def approve
    if current_user.official_role == 'initial_verifier' && @petition.submitted?
      if @petition.update(status: :under_review)
        Notification.notify_approval(@petition.user, @petition)
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
      Notification.notify_rejection(@petition.user, @petition, params[:comments])
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
        Notification.notify_signature_verification(@petition.user, @petition)
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
    begin
      if current_user.petition_handler? && @petition.awaiting_response?
        ActiveRecord::Base.transaction do
          # Aktualizacja statusu petycji
          @petition.update!(status: :responded)
    
          # Tworzenie komentarza typu 'response'
          comment = @petition.petition_comments.create!(
            official: current_user,
            content: params[:comments],
            comment_type: 'response'
          )
    
          # Tworzenie powiadomienia
          Notification.notify_response(@petition.user, @petition, comment)
        end
    
        redirect_to officials_petitions_path, notice: "Petycja otrzymała odpowiedź."
      end
    rescue ActiveRecord::RecordInvalid => e
      redirect_to officials_petitions_path, alert: "Nie udało się dodać odpowiedzi do petycji: #{e.message}"
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
      Notification.notify_unconsidered(@petition.user, @petition, params[:comments])
      redirect_to officials_petitions_path, notice: "Petycja została pozostawiona bez rozpatrzenia."
    else
      redirect_to officials_petitions_path, alert: "Nie udało się zmienić statusu petycji."
    end
  end

  def request_supplement
    # Przekieruj do formularza dodawania komentarza
    redirect_to request_supplement_form_officials_petition_path(@petition)
  end


  def forward_for_response
    if current_user.official_role == 'petition_verifier' && @petition.under_review?
      if @petition.update(status: :awaiting_response)
        Notification.notify_forwarded(@petition.user, @petition)
        redirect_to officials_petitions_path, notice: "Petycja została przekazana do rozpatrzenia."
      else
        redirect_to officials_petitions_path, alert: "Nie udało się przekazać petycji."
      end
    else
      redirect_to officials_petitions_path, alert: "Brak uprawnień do wykonania tej akcji."
    end
  end

  def add_comment
    @comment = @petition.petition_comments.new(comment_params)
    @comment.official = current_user
  
    ActiveRecord::Base.transaction do
      if @comment.request_supplement?
        @petition.update!(status: :supplement_required)
      end
      @comment.save!
      Notification.notify_comment(@petition.user, @petition, @comment)
    end
  
    redirect_to officials_petition_path(@petition), notice: "Komentarz został dodany."
  rescue ActiveRecord::RecordInvalid => e
    @comments = @petition.petition_comments.includes(:official).order(created_at: :asc)
    flash.now[:alert] = "Nie udało się dodać komentarza: #{e.message}"
    render :show
  end

  private

  def set_petition
    @petition = Petition.find(params[:id])
  end

  def comment_params
    params.require(:petition_comment).permit(:content, :comment_type)
  end

end
