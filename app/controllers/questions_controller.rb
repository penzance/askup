class QuestionsController < ApplicationController
  load_and_authorize_resource

  # loads the page showing details for a single question so that a user
  #   can review the answer and specify whether he/she knew the answer
  def show
    @feedback_active = !!current_user
    @new_answer = Answer.new
  end

  # loads the new question page, allowing user to enter a new question/answer combo in a form
  def new
    @question.answers.build
    @qsets = Qset.all
    prev_cookie_id = cookies[:new_question_qset_id].to_i
    if @qsets.map(&:id).include?(prev_cookie_id)
      @question.qset_id = prev_cookie_id
    else
      cookies.delete :new_question_qset_id
    end
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
    @question.user_id = current_user.id
    @question.update(question_params)
    redirect_to qset_path(@question.qset_id), notice: "Your question has been updated!"
  end

  def destroy
    @question.destroy
    redirect_to qset_path(@question.qset_id)
  end

  def feedback
    if ['no', 'yes', 'maybe'].include? params[:correct]
      analyzer.info {"User #{current_user.id} answered #{params[:correct]} for question #{params[:id]}"}
      respond_to do |format|
        format.js { render :nothing => true }
      end
    end 
  end

  private
  def question_params
    # todo: we may need to validate answers_attribute :id so user cannot update someone else's answers
    params.require(:question).permit(:text, :qset_id, answers_attributes: [:id, :text, '_destroy'])
  end
end
