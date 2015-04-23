module QuestionsHelper
  require 'rest-client'
  require 'json'

  def get_question_list
    JSON.parse(RestClient.get(ENV["qm_api_url"] + "questions"))
  end

  def destroy_question question
    json = question.to_json(:include => :answers)
    
    logger.debug "JSON in destroy_question helper: #{json}"

    logger.debug "PARAMS in destroy_question helper: #{params}"

    logger.debug "PARAMS['id'] in destroy_question helper: #{params[:id]}"

    response = RestClient.delete(ENV["qm_api_url"] + 'questions/' + params[:id], :content_type => :json , :accept => :json)

    logger.debug "RESPONSE for question from destroy_question helper: #{response}"

  end

end

