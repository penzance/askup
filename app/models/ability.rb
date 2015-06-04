class Ability
  include CanCan::Ability

  def initialize(user)
    unless user
      can :read, Question
      unless ENV['abilities_unauth_user_can_manage_questions'] == 'true'
        cannot :index, Question
      end
    else
      if user.role? :admin
        can :read, Question
        can :create, Question
        can :manage, Question
        can :manage, User, id: user.id
      elsif user.role? :contributor
        can :read, Question
        can :create, Question
      end
    end
  end
end
