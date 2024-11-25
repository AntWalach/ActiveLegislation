class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_petition

  def create
    @comment = @petition.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @petition, notice: 'Twój komentarz został dodany.'
    else
      @comments = @petition.comments.order(created_at: :desc)
      render 'petitions/show', alert: 'Nie udało się dodać komentarza.'
    end
  end

  def destroy
    @comment = @petition.comments.find(params[:id])

    if @comment.user == current_user || current_user.is_a? Admin
      @comment.destroy
      redirect_to @petition, notice: 'Komentarz został usunięty.'
    else
      redirect_to @petition, alert: 'Nie masz uprawnień do usunięcia tego komentarza.'
    end
  end

  private

  def set_petition
    @petition = Petition.find(params[:petition_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
