module QuestionsHelper
  require 'rest-client'
  require 'json'

  def get_question_list
    JSON.parse(RestClient.get(ENV["qm_api_url"] + "questions"))
  end

  def destroy_question question

    logger.debug "QUESTION ID from AskUp destroy_question: #{params[:id]}"

    # response = RestClient.delete(ENV["qm_api_url"] + 'questions/' + params[:id], :content_type => :json , :accept => :json)


    response = RestClient.delete "#{ENV["qm_api_url"]}/questions/#{params[:id]}"

    logger.debug "RESPONSE from AskUp destroy_question: #{response}"


  end

end

