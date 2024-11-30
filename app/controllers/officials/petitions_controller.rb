class Officials::PetitionsController < ApplicationController
  include TagSimilarity
  before_action :authenticate_user!
  before_action :authenticate_official!
  before_action :set_petition, only: %i[ show approve reject respond request_supplement add_comment transfer unmerge share]
  before_action :require_official


  def index
    petitions_for_department = Petition.completed.where(department: current_user.department).where.not(status: "draft")
    shared_petitions = Petition.shared_with_department(current_user.department)
    
    @petitions = Petition.from(
      "(#{petitions_for_department.to_sql} UNION ALL #{shared_petitions.to_sql}) AS petitions"
    ).order(created_at: :desc).page(params[:page])
  end
  
  def show
    @comments = @petition.official_comments.includes(:official).order(created_at: :asc)
    @comment = OfficialComment.new
  end

  def assign_to_me
    @petition = Petition.find(params[:id])
  
    # Sprawdzenie, czy użytkownik może przypisać petycję do siebie
    if @petition.shared_departments.include?(current_user.department) || @petition.assigned_official.nil?
      if @petition.assigned_users.exists?(current_user.id)
        redirect_to officials_petitions_path, alert: 'Jesteś już przypisany do tej petycji.'
      else
        AssignedOfficial.create!(petition: @petition, user: current_user)
        redirect_to officials_petitions_path, notice: 'Petycja została przypisana do Ciebie.'
      end
    else
      redirect_to officials_petitions_path, alert: 'Nie możesz przypisać tej petycji do siebie.'
    end
  end


  def approve
    if @petition.update(status: :under_review)
      Notification.notify_approval(@petition.user, @petition)
      Notification.notify_new_assignment(current_user, @petition)
      redirect_to officials_petitions_path, notice: "Petycja została zatwierdzona."
    else
      redirect_to officials_petitions_path, alert: "Nie udało się zatwierdzić petycji."
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
    official = Official.find(params[:petition][:assigned_official_id])
  
    # Sprawdzenie, czy urzędnik jest już przypisany
    if @petition.assigned_users.include?(official)
      redirect_to officials_petition_path(@petition), alert: "Ten urzędnik jest już przypisany do petycji."
    else
      ActiveRecord::Base.transaction do
        # Dodaj nowego urzędnika do petycji
        AssignedOfficial.create!(petition: @petition, user: official)
  
        # Usuń siebie z przypisanych urzędników
        AssignedOfficial.where(petition: @petition, user: current_user).destroy_all
      end
  
      redirect_to officials_petition_path(@petition), notice: "Petycja została przypisana wybranemu urzędnikowi, a Ty zostałeś odpięty."
    end
  rescue ActiveRecord::RecordInvalid => e
    redirect_to officials_petition_path(@petition), alert: "Wystąpił błąd podczas przekazywania petycji: #{e.message}"
  end
  
  

  def merge_form
    if params[:primary_petition_id].present?
      @primary_petition = Petition.find(params[:primary_petition_id])
      primary_tags = @primary_petition.tag_list
  
      # Get IDs of primary petitions (those that have merged petitions)
      primary_petition_ids = Petition.where.not(merged_into_id: nil).select(:merged_into_id).distinct.pluck(:merged_into_id)
  
      potential_petitions = Petition.completed
                                    .where.not(id: @primary_petition.id)
                                    .where(department_id: @primary_petition.department_id)
                                    .where(merged_into_id: nil)
                                    .where.not(id: primary_petition_ids)
  
      Rails.logger.debug "Potential Petitions before similarity check: #{potential_petitions.pluck(:id, :title).inspect}"
  
      @similar_petitions = potential_petitions.map do |petition|
        petition_tags = petition.tag_list
        similarity = tag_similarity(primary_tags, petition_tags)
        { petition: petition, similarity: similarity }
      end.select { |entry| entry[:similarity] > 20 }
  
      Rails.logger.debug "Similar Petitions after similarity check: #{@similar_petitions.map { |e| [e[:petition].id, e[:similarity]] }.inspect}"
  
      # Get already merged petitions
      @merged_petitions = @primary_petition.merged_petitions
  
    else
      @primary_petition = nil
      @similar_petitions = []
      @merged_petitions = []
    end
  
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  
  
  

  def merge
    if params[:primary_petition_id].blank?
      redirect_back fallback_location: merge_form_officials_petitions_path, alert: 'Proszę wybrać główną petycję.'
      return
    end
  
    petition_ids = params[:petition_ids] || []
    if petition_ids.empty?
      redirect_back fallback_location: merge_form_officials_petitions_path, alert: 'Proszę wybrać co najmniej jedną petycję do połączenia.'
      return
    end
  
    @primary_petition = Petition.find(params[:primary_petition_id])
    @petitions_to_merge = Petition.where(id: petition_ids)
  
    # Validate that petitions are eligible for merging
    invalid_petitions = @petitions_to_merge.select { |p| p.merged_into_id.present? || p.merged_petitions.any? }
    if invalid_petitions.any?
      redirect_back fallback_location: merge_form_officials_petitions_path, alert: 'Wybrane petycje nie mogą zostać połączone.'
      return
    end
  
    Petition.transaction do
      @petitions_to_merge.each do |petition|
        petition.update!(previous_status: petition.status, status: 'merged', merged_into: @primary_petition)
      end
    end
  
    redirect_to officials_petition_path(@primary_petition), notice: 'Petycje zostały pomyślnie połączone.'
  rescue ActiveRecord::RecordInvalid => e
    redirect_back fallback_location: merge_form_officials_petitions_path, alert: "Wystąpił błąd podczas łączenia: #{e.message}"
  end
  

  def unmerge
    if @petition.merged_petitions.empty?
      redirect_to officials_petition_path(@petition), alert: 'Ta petycja nie została połączona z innymi.'
      return
    end
  
    Petition.transaction do
      @petition.merged_petitions.each do |merged_petition|
        merged_petition.update!(status: merged_petition.previous_status || "submitted", previous_status: nil, merged_into: nil)
      end
    end
  
    redirect_to officials_petition_path(@petition), notice: 'Łączenie petycji zostało cofnięte.'
  rescue ActiveRecord::RecordInvalid => e
    redirect_to officials_petition_path(@petition), alert: "Wystąpił błąd podczas cofania łączenia: #{e.message}"
  end


  def unmerge_selected
    if params[:primary_petition_id].blank?
      redirect_back fallback_location: merge_form_officials_petitions_path, alert: 'Proszę wybrać główną petycję.'
      return
    end
  
    petition_ids = params[:petition_ids] || []
    if petition_ids.empty?
      redirect_back fallback_location: merge_form_officials_petitions_path, alert: 'Proszę wybrać co najmniej jedną petycję do odłączenia.'
      return
    end
  
    @primary_petition = Petition.find(params[:primary_petition_id])
    @petitions_to_unmerge = @primary_petition.merged_petitions.where(id: petition_ids)
  
    Petition.transaction do
      @petitions_to_unmerge.each do |petition|
        petition.update!(status: petition.previous_status || 'submitted', previous_status: nil, merged_into: nil)
      end
    end
  
    redirect_to merge_form_officials_petitions_path(primary_petition_id: @primary_petition.id), notice: 'Wybrane petycje zostały pomyślnie odłączone.'
  rescue ActiveRecord::RecordInvalid => e
    redirect_back fallback_location: merge_form_officials_petitions_path, alert: "Wystąpił błąd podczas odłączania: #{e.message}"
  end

  def share
    departments = Department.where(id: params[:department_ids])
    
    ActiveRecord::Base.transaction do

      petitions_to_share = [@petition] + @petition.merged_petitions
  
      petitions_to_share.each do |petition|
        departments.each do |department|
          petition.shared_departments << department unless petition.shared_departments.include?(department)
        end
      end
    end
    
    redirect_to officials_petition_path(@petition), notice: 'Petycja i powiązane petycje zostały udostępnione wybranym departamentom.'
  rescue ActiveRecord::RecordInvalid => e
    redirect_to officials_petition_path(@petition), alert: "Nie udało się udostępnić petycji: #{e.message}"
  end


  private

  def tag_frequency(tag)
    # Liczba wystąpień danego tagu w całej bazie petycji
    Petition.tag_counts.find { |t| t.name == tag }&.count || 0
  end

  def require_official
    redirect_to authenticated_root, alert: 'Nie masz uprawnień do tej akcji.' unless current_user.is_a?(Official)
  end

  def set_petition
    @petition = Petition.find(params[:id])
  end

  def comment_params
    params.require(:official_comment).permit(:content, :comment_type, attachments: [])
  end

end
