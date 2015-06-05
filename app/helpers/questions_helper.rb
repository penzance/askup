module QuestionsHelper
  require 'rest-client'
  require 'json'

  def get_question_list
    JSON.parse(RestClient.get(ENV["qm_api_url"] + "questions"))
  end

  def get_question(question_id)
    question_json = RestClient.get("#{ENV['qm_api_url']}questions/#{question_id}")
    # todo: this is all pretty convoluted, and there's probably a better way, but it works for now
    question_hash = JSON.parse(question_json)
    answer_hash = question_hash['answers'][0]
    question_hash.delete('answers')
    question = Question.new(question_hash)
    question.answers.new(answer_hash)
    question
  end

  def update_question_by_id(id, params)
    logger.debug "update_question_by_id calling PATCH on question #{id} with params #{params}"
    response = RestClient.patch("#{ENV['qm_api_url']}questions/#{id}", params, :content_type => :json , :accept => :json)
    logger.debug "update_question_by_id received the following response from the question market: #{response}"
  end

  def destroy_question question
    response = RestClient.delete(ENV["qm_api_url"] + 'questions/' + params[:id], :content_type => :json , :accept => :json)
    logger.debug "RESPONSE from AskUp destroy_question: #{response}"
  end

end

