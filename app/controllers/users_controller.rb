class UsersController < ApplicationController
  load_and_authorize_resource

  def show
    # questions for _question_list partial; show only those that
    # current user has permission to identify with this author
    @questions = @user.questions.order(created_at: :desc)
    @questions = @questions.select do |q|
      can? :see_question_author, q
    end
    @questions = @questions[0..4]  # limit to the top 5
    @view_options = {
        question_list: {
            edit_question_from: user_path(@user),
            show_qset_instead_of_author: true,
        }
    }
  end

  def update
    # Note that although users can :manage their own records, we don't have any UI for that yet
    # Only admins should be able to change a user's organization, at the moment, so validate that
    # before allowing actual user updates. In the future we will probably allow users to edit some
    # of their own data where appropriate.
    if current_user.role? :admin
      user_params = params.require(:user).permit(:org_id)
      @user.update(user_params)
      redirect_to @user, notice: "User '#{@user.full_name}' saved."
    else
      redirect_to @user, alert: "Update user '#{@user.full_name}' failed."
    end
  end

end
