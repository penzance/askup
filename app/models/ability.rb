class Ability
  include CanCan::Ability



  def initialize(user)
    user ||= User.new
    if user.role? :admin
      can :read, Question
      can :create, Question
      can :manage, Question
    elsif user.role? :contributor
      can :read, Question
      can :create, Question
    else
      can :create, User
      can :read, Question
    end
  end

end
