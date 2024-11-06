class ReportsController < ApplicationController
  before_action :authenticate_official!

  def annual_report
    @year = params[:year] || Date.current.year - 1
    @petitions = Petition.where("extract(year from updated_at) = ?", @year)
  end
end
