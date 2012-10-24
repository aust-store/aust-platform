class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role == "founder"
      can :manage, AdminUser
      cannot :destroy, AdminUser, :id => user.id
    end

    if user.role == "collaborator"
      can :read, AdminUser
      can :update, AdminUser, :id => user.id
      cannot :destroy, AdminUser, :id => user.id
    end
  end
end