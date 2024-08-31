# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
      if user
        if user.is? :standard
          can [:dashboard], User
          can [:index, :show, :create, :new, :edit, :destroy], Petition
          can [:index, :show, :create, :new, :edit, :destroy], Bill
        end


        if user.is? :admin
          can :manage, :all
        end
      end
  end
end
