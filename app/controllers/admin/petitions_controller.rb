class Admin::PetitionsController < ApplicationController
    before_action :authenticate_user!
    before_action :authenticate_official!
    before_action :require_official
    before_action :set_petition, only: %i[ show approve reject respond request_supplement add_comment transfer unmerge]
  
    def index
      @search = Petition.completed.ransack(params[:q])
      @petitions = @search.result(distinct: true).page(params[:page])
    end
  
    def show
      @comments = @petition.official_comments.includes(:official).order(created_at: :asc)
      @comment = OfficialComment.new
    end
  
    def assign_to_me
      @petition = Petition.find(params[:id])
      if @petition.update(assigned_official: current_user)
        redirect_to officials_petitions_path, notice: 'Petycja została przypisana do Ciebie.'
      else
        redirect_to officials_petitions_path, alert: 'Nie udało się przypisać petycji.'
      end
    end
  
    def approve
      if current_user.official_role == 'petition_officer' && @petition.submitted?
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
  
    def reject
      if @petition.update(status: :rejected, comments: params[:comments])
        Notification.notify_rejection(@petition.user, @petition, params[:comments])
        redirect_to officials_petitions_path, notice: "Petycja została odrzucona."
      else
        redirect_to officials_petitions_path, alert: "Nie udało się odrzucić petycji."
      end
    end
  
    def respond
      begin
        if current_user.petition_handler? && @petition.under_review?
          ActiveRecord::Base.transaction do
            @petition.update!(status: :responded)
  
            comment = @petition.official_comments.create!(
              official: current_user,
              content: params[:comments],
              comment_type: 'response'
            )
  
            Notification.notify_response(@petition.user, @petition, comment)
          end
  
          redirect_to officials_petitions_path, notice: "Petycja otrzymała odpowiedź."
        else
          redirect_to officials_petitions_path, alert: "Brak uprawnień lub petycja nie jest w trakcie przeglądu."
        end
      rescue ActiveRecord::RecordInvalid => e
        redirect_to officials_petitions_path, alert: "Nie udało się dodać odpowiedzi do petycji: #{e.message}"
      end
    end
  
    def merge_petitions
      primary_petition = Petition.find(params[:primary_petition_id])
      petitions_to_merge = Petition.where(id: params[:petition_ids])
  
      petitions_to_merge.update_all(grouped_petition_id: primary_petition.id)
  
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
      redirect_to request_supplement_form_officials_petition_path(@petition)
    end
  
    def add_comment
      @comment = @petition.official_comments.new(comment_params)
      @comment.official = current_user
  
      ActiveRecord::Base.transaction do
        if @comment.request_supplement?
          @petition.update!(status: :awaiting_supplement)
        end
        @comment.save!
        Notification.notify_comment(@petition.user, @petition, @comment)
      end
  
      redirect_to officials_petition_path(@petition), notice: "Komentarz został dodany."
    rescue ActiveRecord::RecordInvalid => e
      @comments = @petition.official_comments.includes(:official).order(created_at: :asc)
      flash.now[:alert] = "Nie udało się dodać komentarza: #{e.message}"
      render :show
    end
  
    def transfer
      @petition.update!(assigned_official_id: params[:petition][:assigned_official_id])
      redirect_to officials_petition_path(@petition), notice: "Petycja została przekazana."
    end
  
    def merge_form
      @petitions = Petition.completed
      @primary_petition = Petition.find(params[:primary_petition_id]) if params[:primary_petition_id]
    end
  
    def merge
      if params[:primary_petition_id].blank?
        redirect_back fallback_location: merge_form_officials_petitions_path, alert: 'Proszę wybrać petycję główną.'
        return
      end
  
      @primary_petition = Petition.find(params[:primary_petition_id])
      petition_ids = params[:petition_ids] || []
      @petitions_to_merge = Petition.where(id: petition_ids).where.not(id: @primary_petition.id)
  
      if @petitions_to_merge.empty?
        redirect_back fallback_location: merge_form_officials_petitions_path, alert: 'Proszę wybrać co najmniej jedną petycję do połączenia.'
        return
      end
  
      Petition.transaction do
        @petitions_to_merge.each do |petition|
          petition.update!(previous_status: petition.status)
          petition.update!(status: 'merged', merged_into: @primary_petition)
        end
      end
  
      redirect_to officials_petition_path(@primary_petition), notice: 'Petycje zostały pomyślnie połączone.'
    rescue ActiveRecord::RecordInvalid => e
      redirect_back fallback_location: merge_form_officials_petitions_path, alert: "Wystąpił błąd podczas łączenia: #{e.message}"
    end
  
    def unmerge
      unless @petition.merged_petitions.any?
        redirect_to officials_petition_path(@petition), alert: 'Ta petycja nie została połączona z innymi.'
        return
      end
  
      Petition.transaction do
        merged_petitions = @petition.merged_petitions
  
        merged_petitions.each do |merged_petition|
          merged_petition.update!(status: merged_petition.previous_status || :submitted, merged_into: nil)
          merged_petition.update!(previous_status: nil)
        end
  
        @petition.merged_petitions.update_all(merged_into_id: nil)
  
        redirect_to officials_petition_path(@petition), notice: 'Łączenie petycji zostało cofnięte.'
      end
    rescue ActiveRecord::RecordInvalid => e
      redirect_to officials_petition_path(@petition), alert: "Wystąpił błąd podczas cofania łączenia: #{e.message}"
    end
  
    private
  
    def require_official
      redirect_to authenticated_root_path, alert: 'Nie masz uprawnień do tej akcji.' unless current_user.is_a?(Admin)
    end
  
    def set_petition
      @petition = Petition.find(params[:id])
    end
  
    def comment_params
      params.require(:official_comment).permit(:content, :comment_type, attachments: [])
    end
  end
  