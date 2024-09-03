# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
      if user
        if user.is? :standard
          can [:dashboard, :upload_public_key], User
          can [:index, :show, :create, :new, :edit, :destroy], Petition
          can [:index, :show, :create, :new, :edit, :destroy], Bill
          can [:create], Signature
        end


        if user.is? :admin
          can :manage, :all
        end
      end
  end
end
