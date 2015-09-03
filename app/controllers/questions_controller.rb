class QuestionsController < ApplicationController
  # todo: helper should only have View helper code, not business logic, so work to remove the dependency here
  include QuestionsHelper
  authorize_resource

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
  end

  # loads the new question page, allowing user to enter a new question/answer combo in a form
  def new
    @question = Question.new
    @question.answers.build
    @qsets = Qset.all
  end

  # handles the request to save a new question (called from the new question page)
  def create
    question = Question.new(question_params)
    question.user_id = current_user.id
    question.save
    msg = "Your question has been submitted! Enter another if you would like."
    redirect_to new_question_path, notice: msg
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
    analyzer.info {"User #{current_user.id} #{user_knowledge} question #{params[:id]}"}
    respond_to do |format|
        format.js { render :nothing => true }
    end
  end

  # todo: do we need to remove :id for the create params, so you can't create a specific answer or question id?
  private
  def question_params
    params.require(:question).permit(:id, :text, :qset_id, answers_attributes: [:id, :text, '_destroy'])
  end
end
