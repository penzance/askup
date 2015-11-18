class QsetsController < ApplicationController
  load_and_authorize_resource

  # shows all qsets
  def index
      if current_user.org.nil?
        redirect_to root_url, alert: "You are not part of an organization."
      else
        redirect_to (current_user.org) 
      end
  end
 
  # handles the request to show all questions in a qset
  def show
    @question_counts = Question.all.group(:qset_id).count
    @feedback_active = !!current_user
    @questions = Question.includes(:answers).where(qset_id: @qset.id).order(created_at: :desc)
    @filter_mine = true if cookies[:all_mine_other_filter] == 'mine'
    @filter_other = true if cookies[:all_mine_other_filter] == 'other'
    @filter_all = true unless @filter_mine or @filter_other
    if @qset.parent.nil?
      @qsets = Qset.where(parent_id: @qset.id)
      render :organizationpage
    else 
      @qsets = Qset.where(parent_id: @qset.id)
      render :classpage
    end
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
