class Ability
  include CanCan::Ability

  def initialize(user)
    unless user  # if the request is from someone who is not logged in
      can :read, Question
      can :read, Qset
      unless Rails.configuration.askup.abilities.unauth_user_can_see_question_lists
        cannot :index, Question
        cannot :read, Qset
      end
    else
      if user.role? :admin
        can :manage, :all
      elsif user.role? :contributor
        can :read, Question
        can :create, Question
        can :manage, Question, :user_id => user.id
        can :read, Qset
        can :manage, User, :id => user.id
      end
    end
  end
end

