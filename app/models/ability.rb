class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      case user
        when Admin
          can :manage, :all
        when Official
          can [:index, :show, :approve, :reject], Petition
          can [:index, :show, :create, :new, :edit, :destroy], Bill
          can [:dashboard], User
        when StandardUser
          can [:dashboard, :upload_public_key], User
          can [:index, :show, :create, :new, :edit, :destroy, :submit, :start_collecting_signatures], Petition
          can [:index, :show, :create, :new, :edit, :destroy, :initialize_committee_formation, :start_collecting_signatures], Bill
          can [:petition_create, :bill_create ], Signature
      end
    end
  end
end
