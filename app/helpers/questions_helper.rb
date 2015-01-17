module QuestionsHelper
  require 'rest-client'
  require 'json'

  def get_question_list
    JSON.parse(RestClient.get(ENV["qm_api_url"] + "questions"))
  end

  def post_question question
    json = question.to_json(:include => :answers)
    response = RestClient.post(ENV["qm_api_url"] + 'questions', json, :content_type => :json , :accept => :json)
    logger.debug "THIS IS THE #{response}"
  end
end

