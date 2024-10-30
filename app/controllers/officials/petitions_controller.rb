class Officials::PetitionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_official!

  def index
    @search = Petition.where(status: :pending).ransack(params[:q])
    @petitions = @search.result(distinct: true).page(params[:page])
  end

  def show
    @petition = Petition.find(params[:id])
  end

  def approve
    petition = Petition.find(params[:id])
    if petition.update(status: :approved, comments: params[:comments])
      redirect_to officials_petitions_path, notice: "Petycja została zatwierdzona."
    else
      redirect_to officials_petitions_path, alert: "Nie udało się zatwierdzić petycji."
    end
  end

  def reject
    petition = Petition.find(params[:id])
    petition.update(status: :rejected, comments: params[:comments])
    redirect_to officials_petitions_path, notice: "Petycja została odrzucona."
  end
  
  def destroy
    petition = Petition.find(params[:id])
    petition.destroy
    redirect_to officials_petitions_path, notice: "Petycja została usunięta."
  end

  private

  def authorize_official!
    redirect_to root_path, alert: "Nie masz dostępu do tej strony" unless Official
  end
end
