class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      case user
        when Admin
          can :manage, :all
        when Official
          can [:read,:index, :show, :approve, :reject, :forward_for_response, :request_supplement, :add_comment], Petition
          can [:index, :show, :create, :new, :edit, :destroy], Bill
          can [:dashboard, :show], User
          can :manage, Petition, department_id: user.department_id
          can :manage, Petition, assigned_official_id: user.id
        when StandardUser
          can [:dashboard, :show], User
          can [:index, :show, :create, :new, :edit, :update, :destroy, :submit], Petition
          can [:index, :show, :create, :new, :edit, :destroy, :initialize_committee_formation, :start_collecting_signatures], Bill
          can [:petition_create, :bill_create ], Signature
      end
    end
  end
end
