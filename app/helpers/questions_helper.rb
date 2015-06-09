module QuestionsHelper
  require 'rest-client'
  require 'json'

  # todo: find a better way to use a global variable, e.g. a config (but one that shouldn't be overwritten)
  ROOT_QUESTION_GROUP_ID = 1

  def get_question_list
    JSON.parse(RestClient.get(ENV["qm_api_url"] + "questions"))
  end

  def get_question_groups
    JSON.parse(RestClient.get(ENV["qm_api_url"] + "question_groups"))
  end

  # formats an array of QuestionGroup options at a given level of the
  # QuestionGroup hierarchy for a <select> entity in a view
  # Returns: all QuestionGroups that are children of current_group_id, plus a default
  #          'choose a subgroup' option, plus a 'new group' option if user is admin,
  #          or an empty array if no child groups exist with parent of current_group_id
  def get_question_group_children_option_list(group_list, current_group_id)
    child_groups_context = group_list.select {|g| g['parent_id'] == current_group_id}
    child_groups_context.map!{|h| [h['name'], h['id']]}
    if current_user and current_user.role?(:admin)
      child_groups_context.unshift(['(choose a subgroup)', ''])
      child_groups_context << ['(new group)', 'new']
    elsif !child_groups_context.empty?
      child_groups_context.unshift(['(choose a subgroup)', ''])
    end
    child_groups_context
  end

  # formats an array of all available QuestionGroup options for a <select> entity in a view
  def get_question_group_option_list(group_list)
    context = group_list.map{|h| [h['name'], h['id']]}
  end

  # builds an array of QuestionGroups in order of parents > children for display
  # in a breadcrumb-style arrangement in a view, where current_group_id is the last child
  def get_question_group_context(group_list, current_group_id)
    question_group_context = Array.new
    render_question_group_and_parents = Proc.new do |group_id|
      group = group_list.find {|g| g['id'] == group_id}
      question_group_context.unshift(group)
      unless group['parent_id'].nil? || group['parent_id'] < ROOT_QUESTION_GROUP_ID
        render_question_group_and_parents.call(group['parent_id'])
      end
    end
    render_question_group_and_parents.call(current_group_id)
    question_group_context
  end

  # Returns true if group_id exists in the group_list, or false if it cannot be found
  def valid_group?(group_list, group_id)
    !!group_list.find {|g| g['id'] == group_id}
  end

  def get_question(question_id)
    question_json = RestClient.get("#{ENV['qm_api_url']}questions/#{question_id}")
    logger.debug "get_question received the following response from the question market: #{question_json}"
    # todo: this is all pretty convoluted, and there's probably a better way, but it works for now
    question_hash = JSON.parse(question_json)
    answer_hash = question_hash['answers'][0]
    question_hash.delete('answers')
    # question_group_hash = question_hash['question_group']
    question_hash.delete('question_group')
    question = Question.new(question_hash)
    question.answers.new(answer_hash)
    question
  end

  def update_question_by_id(id, params)
    response = RestClient.patch("#{ENV['qm_api_url']}questions/#{id}", params, :content_type => :json , :accept => :json)
    logger.debug "update_question_by_id received the following response from the question market: #{response}"
  end

  def destroy_question_by_id(id)
    response = RestClient.delete("#{ENV['qm_api_url']}questions/#{id}", :content_type => :json , :accept => :json)
    logger.debug "destroy_question_by_id received the following response from the question market: #{response}"
  end

  def qgid_from_request(params)
  current_question_group_id = params.has_key?(:question_group_id) ? Integer(params[:question_group_id]) : ROOT_QUESTION_GROUP_ID
    session[:question_index_question_group_id] = current_question_group_id
  end

  def qgid_from_session
    session[:question_index_question_group_id] ||= ROOT_QUESTION_GROUP_ID
  end
end

