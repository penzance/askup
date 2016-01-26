class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil?  # if the request is from someone who is not logged in
      can :read, Qset do |qset|
        qset.settings(:permissions).questions_visible_to_unauth_user
      end
      can :see_all_questions, Qset do |qset|
        qset.settings(:permissions).all_questions_visible
      end
      can :read, Question
      can :see_question_author, Question do |q|
        q.qset.settings(:permissions).question_authors_visible
      end
    else
      if user.role? :admin
        can :manage, :all
        can :see_all_questions, Qset
        can :see_question_author, Question
      elsif user.role? :contributor
        can :read, Qset
        can :see_all_questions, Qset do |qset|
          qset.settings(:permissions).all_questions_visible
        end
        can [:downvote, :read, :upvote], Question do |q|
          q.qset.settings(:permissions).all_questions_visible
        end
        can :manage, Question, :user_id => user.id
        can :see_question_author, Question do |q|
          (q.qset.settings(:permissions).question_authors_visible or q.user == user)
        end
        can :manage, User, :id => user.id
        can :read, User
      end
    end
  end
end

