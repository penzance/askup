class QsetsController < ApplicationController
  load_and_authorize_resource

  # shows all qsets
  def index
    @qsets = @qsets.order(:name)
    @question_counts = Question.all.group(:qset_id).count
  end

  # handles the request to show all questions in a qset
  def show
    @questions = Question.includes(:answers).where(qset_id: @qset.id).order(created_at: :desc)
    # todo: define in some central configuration area on init / load of app
    @question_limitations = ENV["limit_question_index_to_users_questions_only"]
  end

  # handles the request to save a new qset
  # (called from the new qset modal)
  def create
    create_group_params = params.permit(:name, :parent_id)
    @qset = Qset.new(create_group_params)
    @qset.save
    redirect_to qset_path(@qset), notice: "Qset '#{@qset.name}' created."
  end

  # handles the request to update an existing qset
  # (called from the edit qset modal)
  def update
    # note: parent_id is not changeable via this UI
    update_group_params = params.permit(:id, :name)
    @qset.update(update_group_params)
    redirect_to qset_path(@qset.id), notice: "Qset '#{@qset.name}' saved."
  end

  def destroy
    if @qset.destroy
      redirect_to qset_path(@qset.parent_id), notice: "Qset deleted."
    else
      redirect_to qset_path(@qset), alert: "Qset could not be deleted."
    end
  end
end
