class Ability
  include CanCan::Ability


  def initialize(user)
    unless user
      can :read, Question
      cannot :index, Question
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



    # user ||= User.new
    # if user.role? :admin
    #   can :read, Question
    #   can :create, Question
    #   can :manage, Question
    #   can :manage, User, id: user.id
    # elsif user.role? :contributor
    #   can :read, Question
    #   can :create, Question
    # else
    #   # can :create, User
    #   can :read, :all

  #   end
  # end
  #end


