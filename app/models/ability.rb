class Ability
  include CanCan::Ability

  def initialize(user)
    unless user  # if the request is from someone who is not logged in
      can :read, Question
      unless ENV['abilities_unauth_user_can_index_questions'] == 'true'
        cannot :index, Question
      end
    else
      if user.role? :admin
        can :read, Question
        can :create, Question
        can :manage, Question
        can :manage, User
      elsif user.role? :contributor
        can :read, Question
        can :create, Question
        can :manage, Question, :user_id => user.id  # further checks in controller, backend
        can :manage, User, :id => user.id
      end
    end
  end
end

