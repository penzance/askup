class QuestionsController < ApplicationController
  # todo: helper should only have View helper code, not business logic, so work to remove the dependency here
  include QuestionsHelper
  authorize_resource

  # loads the review questions page, which has a modal for showing individual questions
  def index
    @feedback_active = !!current_user
    @current_question_group_id = qgid_from_request(params)
    @questions = Question.includes(:answers).where(question_group_id: @current_question_group_id).order(created_at: :desc)
    question_groups = QuestionGroup.all
    if valid_group?(question_groups, @current_question_group_id)
      # todo: refactor to use .parent, and move this logic into the View?
      @is_question_group_deletable = true
      @question_group_context = get_question_group_context(question_groups, @current_question_group_id)
      @children_option_list = get_question_group_children_option_list(question_groups, @current_question_group_id)
      @question_limitations = ENV["limit_question_index_to_users_questions_only"]
      @my_questions = @questions.select{|question| question["user_id"] == current_user.id} if current_user
    else
      # fixme: if ROOT_QUESTION_GROUP_ID is invalid this will cause an infinite loop (should be fixed by QG refactoring)
      redirect_to questions_path, alert: "There was a problem with your request."
    end
  end

  # loads the page showing details for a single question so that a user
  #   can review the answer and specify whether he/she knew the answer
  def show
    @feedback_active = !!current_user
    @question = Question.find(params[:id])
    @new_answer = Answer.new
  end

  # loads the edit page, allowing user to edit a question/answer combo
  def edit
    @question = Question.find(params[:id])
    # todo: move this check back into ability.rb
    authorize! :update, @question
    @question_groups = get_question_group_option_list(QuestionGroup.all)
    @current_question_group_id = qgid_from_session
  end

  # loads the new question page, allowing user to enter a new question/answer combo in a form
  def new
    @question = Question.new
    @current_question_group_id = qgid_from_request(params)
    @question.question_group_id = @current_question_group_id
    @question.answers.build
    @question_groups = get_question_group_option_list(QuestionGroup.all)
  end

  # handles the request to save a new question (called from the new question page)
  def create
    question = Question.new(question_params)
    question.user_id = current_user.id
    question.save
    msg = "Your question has been submitted! Enter another if you would like."
    redirect_to new_question_path(question_group_id: question.question_group_id), notice: msg
  end

  # handles the request to update an existing question (called from the edit question page)
  # Note: when question or answer is modified (updated_at changes), the other one doesn't necessarily get modified.
  #   If we wanted to change both every time either changed, we could use PUT instead of PATCH. However, we might
  #   not want to update both, because it would be good to know when the question has changed so the answer is now
  #   out-of-date, for example.
  def update
    question = Question.find(params[:id])
    question.user_id = current_user.id
    question.update(question_params)
    redirect_to edit_question_path(params[:id]), notice: "Your question has been updated!"
  end

  def destroy
    question_to_delete = Question.find(params[:id])
    # todo: move this check into ability.rb
    if current_user.role != :admin and question_to_delete.user_id != current_user.id
      flash[:alert] = "Something went wrong; could not complete your request."
    else
      question_to_delete.destroy
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

  # todo: do we need to remove :id for the create params, so you can't create a specific answer or question id?
  private
  def question_params
    params.require(:question).permit(:id, :text, :question_group_id, answers_attributes: [:id, :text, '_destroy'])
  end
end
