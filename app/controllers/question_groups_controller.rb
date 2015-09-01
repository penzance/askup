class QuestionGroupsController < ApplicationController
  authorize_resource

  # handles the request to save a new question group
  # (called from the new question group modal)
  def create
    create_group_params = params.permit(:name, :parent_id)
    question_group = QuestionGroup.new(create_group_params)
    question_group.save
    redirect_to questions_path(question_group_id: question_group.id),
                notice: "Question group '#{question_group.name}' created."
  end

  # handles the request to update an existing question group
  # (called from the edit question group modal)
  def update
    # note: parent_id is not changeable via this UI
    update_group_params = params.permit(:id, :name)
    question_group = QuestionGroup.find(params[:id])
    question_group.update(update_group_params)
    msg = "Question group '#{question_group.name}' saved."
    redirect_to questions_path(question_group_id: question_group.id), notice: msg
  end

  def destroy
    delete_group_params = params.permit(:id)
    question_group = QuestionGroup.find(params[:id])
    parent_id = question_group.parent_id
    if question_group.destroy
      redirect_to questions_path(question_group_id: parent_id),
                  notice: "Question group deleted."
    else
      redirect_to questions_path(question_group_id: params[:id]),
                  alert: "Question group could not be deleted."
    end
  end
end
