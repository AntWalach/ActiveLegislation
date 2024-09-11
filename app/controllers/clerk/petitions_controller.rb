module Clerk
    class PetitionsController < ApplicationController
      before_action :authenticate_user!
      before_action :authorize_clerk!
  
      def index
        @petitions = Petition.where(status: :under_review)
      end
  
      def show
        @petition = Petition.find(params[:id])
      end
  
      def approve
        petition = Petition.find(params[:id])
        petition.update(status: :approved)
        redirect_to clerk_petitions_path, notice: "Petycja została zatwierdzona."
      end
  
      def reject
        petition = Petition.find(params[:id])
        petition.update(status: :rejected)
        redirect_to clerk_petitions_path, notice: "Petycja została odrzucona."
      end
  
      private
  
      def authorize_clerk!
        redirect_to root_path, alert: "Nie masz dostępu do tej strony" unless current_user.is?(:official)
      end
    end
  end
  