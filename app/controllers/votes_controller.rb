class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    @petition = Petition.find(params[:petition_id])
    @vote = @petition.votes.build(user: current_user)

    if @vote.save
      redirect_to @petition, notice: 'Twój głos został dodany.'
    else
      redirect_to @petition, alert: @vote.errors.full_messages.to_sentence
    end
  end

  def destroy
    @petition = Petition.find(params[:petition_id])
    @vote = @petition.votes.find_by(user: current_user)

    if @vote
      @vote.destroy
      redirect_to @petition, notice: 'Twój głos został usunięty.'
    else
      redirect_to @petition, alert: 'Nie oddałeś głosu na tę petycję.'
    end
  end
end
