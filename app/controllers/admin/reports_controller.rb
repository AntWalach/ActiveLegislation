class Admin::ReportsController < ApplicationController
  helper Admin::ReportsHelper

  def index
    # Pobierz parametry filtrów lub ustaw domyślne wartości
    from_date = params[:from_date].present? ? Date.parse(params[:from_date]) : Petition.minimum(:created_at)&.to_date || Date.today
    to_date = params[:to_date].present? ? Date.parse(params[:to_date]) : Petition.maximum(:created_at)&.to_date || Date.today
    status = params[:status]

    # Filtruj petycje na podstawie parametrów
    @petitions = Petition.where(created_at: from_date.beginning_of_day..to_date.end_of_day)
    @petitions = @petitions.where(status: status) if status.present?

    # Statystyki ogólne
    @total_petitions = @petitions.count
    @petitions_in_last_month = @petitions.where(created_at: 1.month.ago.beginning_of_month..1.month.ago.end_of_month).count
    @petitions_requiring_action = @petitions.where(status: [:submitted, :under_review]).count

    # Średni czas odpowiedzi
    @average_response_time = @petitions.where.not(submission_date: nil, response_deadline: nil)
                                       .average('DATEDIFF(response_deadline, submission_date)') || 0

    # Grupowanie według statusu
    @petitions_by_status = @petitions.group(:status).count
    @petitions_status_labels = @petitions_by_status.keys.map { |status| Petition.statuses.key(status) || "Nieznany status" }
    @petitions_status_values = @petitions_by_status.values

    # Grupowanie według tagów
    @petitions_by_tag = @petitions.joins(:tags).group("tags.name").count

    # Grupowanie według roku i miesiąca
    @petitions_by_month = @petitions
      .group("YEAR(created_at)", "MONTH(created_at)")
      .order("YEAR(created_at)", "MONTH(created_at)")
      .count
    @formatted_petitions_by_month = @petitions_by_month.map do |(year, month), count|
      ["#{Date::MONTHNAMES[month]} #{year}", count]
    end.to_h

    # Grupowanie według departamentu
    @petitions_by_department = @petitions.joins(:department).group('departments.name').count

    # Grupowanie według typu petycji
    @petitions_by_type = @petitions.group(:petition_type).count
    @petition_type_labels = @petitions_by_type.keys.map { |type| Petition.petition_types.key(type) || "Nieznany" }
    @petition_type_values = @petitions_by_type.values

    # Najpopularniejsze tagi w filtrowanych petycjach
    @top_tags = ActsAsTaggableOn::Tag.joins(:taggings)
                                     .where(taggings: { taggable_type: 'Petition', taggable_id: @petitions.select(:id) })
                                     .group('tags.id')
                                     .order('COUNT(taggings.id) DESC')
                                     .limit(10)
                                     .select('tags.*, COUNT(taggings.id) as taggings_count')

    # Petycje z największą liczbą wyświetleń
    @top_petitions_by_views = @petitions.order(views: :desc).limit(10)

    respond_to do |format|
      format.html
      format.csv { send_data generate_csv(@petitions), filename: "petitions-#{Date.today}.csv" }
    end
  end

  private

  def generate_csv(petitions)
    CSV.generate(headers: true) do |csv|
      csv << ["ID", "Tytuł", "Status", "Data utworzenia"]
      petitions.each do |petition|
        csv << [petition.id, petition.title, petition.status, petition.created_at]
      end
    end
  end
end
