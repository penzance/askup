class QsetsController < ApplicationController
  load_and_authorize_resource

  # shows the organization qset that the user is a part of, otherwise displays an error message 
  def index
    if current_user.org.nil?
      redirect_to root_url, alert: "Please contact user support at support@askup.net."
    else
      redirect_to (current_user.org) 
    end
  end

  def show
  respond_to do |format|
    format.html { show_qset_html }
    format.json { show_qset_json }
    end
  end

  # returns ordered list of questions that have been pre-filtered based on current_user's permissions
  def get_ordered_questions
    # sorts by default by net votes; secondary sort by create date
    @questions = Question.includes(:answers).where(qset_id: @qset.id).plusminus_tally.order(created_at: :desc)
    @questions = @questions.where(user_id: current_user) if cannot? :see_all_questions, @qset
  end

  # handles the request to show different views depending on qset type
  def show_qset_html
    # check if view needs to render question counts for subsets
    if @qset.settings(:permissions).qset_type != 'questions'
      @qsets = @qset.children
      # a hash of qset question counts keyed by qset id
      @subset_question_counts = @qsets.map do |s|
        count = 0
        s.question_count_descendants.each do |q|
          if q.settings(:permissions).qset_type != 'subsets'
            scope = q.questions
            scope = scope.where(user_id: current_user) if cannot? :see_all_questions, q
            count += scope.count
          end
        end
        [s.id, count]
      end.to_h
    end
    # check if view needs to render questions
    if @qset.settings(:permissions).qset_type != 'subsets'
      @feedback_active = !!current_user
      get_ordered_questions
      if can? :see_all_questions, @qset
        @filter_mine = true if cookies[:all_mine_other_filter] == 'mine'
        @filter_other = true if cookies[:all_mine_other_filter] == 'other'
        @filter_all = true unless @filter_mine or @filter_other
      else
        # show only the current user's questions
        cookies[:all_mine_other_filter] = 'mine'
        @filter_mine = true
      end
      # display questions view
      if @qset.settings(:permissions).qset_type == 'questions'
        render :show_questions
      end
    else
      render :show_subsets
    end
  end

  def show_qset_json
    filter = params.permit(:filter).fetch(:filter, '')
    get_ordered_questions
    if filter == 'other'
      @questions = @questions.where.not(user_id: current_user)
    elsif filter =='mine'
      @questions = @questions.where(user_id: current_user)
    end
    render json: @questions
  end

  # handles the request to save a new qset
  # (called from the new qset modal)
  def create
    create_group_params = params.permit(:name, :parent_id)
    @qset = Qset.new(create_group_params)
    qset_type = params.permit(:qset_type)
    # set qset type from new qset modal
    @qset.settings(:permissions).qset_type = qset_type[:qset_type]
    @qset.save
    redirect_to qset_path(@qset.id), notice: "Qset '#{@qset.name}' created."
  end

  # handles the request to update an existing qset
  # (called from the edit qset modal)
  def update
    # note: parent_id is not changeable via this UI
    update_group_params = params.require(:qset).permit(:name)
    @qset.update(update_group_params)

    update_settings_params =  params.require(:qset).require(:permissions).permit(
        :all_questions_visible,
        :question_authors_visible,
        :questions_visible_to_unauth_user,
        :qset_type
    )
    @qset.update_permissions update_settings_params, true

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
