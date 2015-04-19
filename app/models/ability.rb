class Ability
  include CanCan::Ability



  def initialize(user)
    user ||= User.new
    if user.role? :admin
      can :read, Question
      can :create, Question
    elsif user.role? :contributor
      can :read, Question
      can :create, Question
    else
      can :create, User
    end
  end

end
