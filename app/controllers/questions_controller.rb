class QuestionsController < ApplicationController
  load_and_authorize_resource

  before_filter -> { flash.now[:notice] = flash[:notice].html_safe if flash[:html_safe] && flash[:notice] }


  # loads the page showing details for a single question so that a user
  #   can review the answer and specify whether he/she knew the answer
  def show
    @feedback_active = !!current_user
    @new_answer = @question.answers.new
  end

  # loads the new question page, allowing user to enter a new question/answer combo in a form
  # a GET request to this endpoint with the qset={qset_id} param will set the default qset
  # in the form; if that is not present, check if there is a default qset specified in the
  # session cookies (e.g. by a previously created question). If no valid default qset can be
  # determined, do not set the default qset to anything (make user choose from available qsets)
  def new
    @question.answers.build
    # user-accessible qsets (qsets in the user's org) that can store questions
    # (note that the root/org qset is explicitly not included / allowed)
    @qsets = current_user.org.descendants
    if params[:qset]
      # if the request param is valid, use it
      selected_qset = get_valid_qset(@qsets, params[:qset].to_i)
    else
      # if we have a cookie, use it
      # (the to_i call returns nil if it's not a valid integer)
      cookie_default_qset_id = cookies[:new_question_qset_id].to_i
      if cookie_default_qset_id
        selected_qset = get_valid_qset(@qsets, cookie_default_qset_id)
      else
        # we don't have a valid cookie value for the default qset, so remove the cookie
        # (the UI will not set a default for it to be reset by the client)and
        cookies.delete :new_question_qset_id
        selected_qset = nil
      end
    end

    if selected_qset
      @question.qset_id = selected_qset.id
      @qset_name = selected_qset.name
    end
  end

  # handles the request to save a new question (called from the new question page)
  def create
    question = current_user.questions.new(question_params)
    question.answers.first.creator = current_user
    question.save

    # users get one vote for their own questions by default
    # (so their karma/score improves as they create questions)
    current_user.vote_for(question)

    msg = %Q[Your question has been submitted! View it #{view_context.link_to("here", qset_path(question_params[:qset_id]))}].html_safe
    redirect_to new_question_path, notice: msg, flash: { html_safe: true }
  end

  # handles the request to update an existing question (called from the edit question page)
  # Note: when question or answer is modified (updated_at changes), the other one doesn't necessarily get modified.
  #   If we wanted to change both every time either changed, we could use PUT instead of PATCH. However, we might
  #   not want to update both, because it would be good to know when the question has changed so the answer is now
  #   out-of-date, for example.
  def update
    @question.user_id = current_user.id
    @question.update(question_params)
    redirect_to qset_path(@question.qset), notice: "Your question has been updated!"
  end

  def destroy
    @question.destroy
    redirect_to qset_path(@question.qset)
  end

  def feedback
    if ['no', 'yes', 'maybe'].include? params[:correct]
      analyzer.info {"User #{current_user.id} answered #{params[:correct]} for question #{params[:id]}"}
      respond_to do |format|
        format.js { render :nothing => true }
      end
    end 
  end

  def upvote
    current_user.vote_for(@question)
    respond_to do |format|
      format.js { render json: @question.plusminus }
    end
  end

  def downvote
    current_user.vote_against(@question)
    respond_to do |format|
      format.js { render json: @question.plusminus}
    end
  end

  private
  def question_params
    # todo: we may need to validate answers_attribute :id so user cannot update someone else's answers
    params.require(:question).permit(:text, :qset_id, answers_attributes: [:id, :text, '_destroy'])
  end

  # helper method for checking if a Qset with a given id is a member of a list of Qsets
  # returns the matching Qset in an array (list) of Qsets (matches by id)
  # if no Qset is found for qset_id, returns nil
  def get_valid_qset(qset_list, qset_id)
    index = qset_list.find_index {|qset| qset.id == qset_id}
    if index
      qset_list[index]
    else
      nil
    end
  end
end
