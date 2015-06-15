class QuestionsController < ApplicationController
  include QuestionsHelper
  authorize_resource

  # loads the review questions page, which has a modal for showing individual questions
  def index
    @current_question_group_id = qgid_from_request(params)
    unordered_questions = get_question_list
    filtered_questions = unordered_questions.select{|q| q['question_group_id'] == @current_question_group_id}
    @questions = filtered_questions.sort_by{|hash| [hash['created_at']]}.reverse!
    question_groups = get_question_groups
    if valid_group?(question_groups, @current_question_group_id)
      @is_question_group_deletable = @current_question_group_id != ROOT_QUESTION_GROUP_ID
      @question_group_context = get_question_group_context(question_groups, @current_question_group_id)
      @children_option_list = get_question_group_children_option_list(question_groups, @current_question_group_id)
      @question_limitations = ENV["limit_question_index_to_users_questions_only"]
      @my_questions = @questions.select{|question| question["user_id"] == current_user.id} if current_user
    else
      # fixme: if ROOT_QUESTION_GROUP_ID is invalid this will cause an infinite loop
      redirect_to questions_path, alert: "There was a problem with your request."
    end
  end

  # loads the page showing details for a single question so that a user
  #   can review the answer and specify whether he/she knew the answer
  def show
    @question_id = params[:id]
    question = get_question(@question_id)
    @question = question.text
    @answers = question.answers
    @answer = Answer.new
  end

  # loads the edit page, allowing user to edit a question/answer combo
  #   authorization uses models/ability.rb, but we need to get the question
  #   object from the QuestionMarket before we can authorize
  def edit
    @question = get_question(params[:id])
    authorize! :update, @question
    @answers = @question.answers
    @answer = @answers[0]
    @question_groups = get_question_group_option_list(get_question_groups)
    @current_question_group_id = qgid_from_session
  end

  # loads the new question page, allowing user to enter a new question/answer combo in a form
  def new
    @question = Question.new
    @current_question_group_id = qgid_from_request(params)
    @question.question_group_id = @current_question_group_id
    @question.answers.build
    @question_groups = get_question_group_option_list(get_question_groups)
  end

  # handles the request to save a new question to the backend (called from the new question page)
  def create
    question = Question.new(params.require(:question)
      .permit(:text, :question_group_id,
        answers_attributes:[:text]))
    question.user_id = current_user.id
    question.post_question(question)
    msg = "Your question has been submitted! Enter another if you would like."
    redirect_to new_question_path(question_group_id: question.question_group_id), notice: msg
  end

  # handles the request to update an existing question to the backend (called from the edit question page)
  def update
    question = Question.new(params.require(:question).permit(:id, :text, :question_group_id))
    question.user_id = current_user.id
    answer = Answer.new
    # there's probably some way to build this from the params, but couldn't figure it out, so using this
    #   explicit encode + implicit decode workaround for the moment
    answer.from_json(ActiveSupport::JSON.encode(params['question']['answers_attributes']['0']))
    # there's probably some way to update the answer as part of the question, since it is an associated
    #   object, but couldn't figure it out so using this two-step update for now
    #   note that we don't have enough (reliable) information on the frontend to authorize before calling
    #   the backend, so we need to rely on the backend to authorize the action, so we send along info
    #   about the current user as well
    question.update current_user.as_json
    answer.update current_user.as_json
    redirect_to edit_question_path(params[:id]), notice: "Your question has been updated!"
  end

  def destroy
    # the question market API doesn't currently support user sessions, and we can't send a payload as part of the
    # standard HTTP DELETE request, so this is the only place to check for security violations at the moment.
    # Check the user ID of the question against the current user's ID if the current user isn't an admin
    question_to_delete = get_question(params[:id])
    if current_user.role != :admin and question_to_delete.user_id != current_user.id
      flash[:alert] = "Something went wrong; could not complete your request."
    else
      destroy_question_by_id(params[:id])
    end
    redirect_to questions_path
  end

  def feedback
    user_knowledge = (params[:correct] == "yes" ? "knew" : "didn't know")
    analyzer.info("User #{current_user.id} #{user_knowledge} question #{params[:id]}")
    respond_to do |format|
        format.js { render :nothing => true }
    end
  end

end
