class Ability
  include CanCan::Ability


  user || = User.new
  def initialize(user)
    if user.admin?
      can :read, Question
    else
      can :create, User

  end
end