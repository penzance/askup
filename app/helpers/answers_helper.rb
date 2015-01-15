module AnswersHelper

  def add_answer answer
    json = answer.to_json
    response = RestClient.post(ENV["qm_api_url"] + "questions/#{params[:question_id]}/answers", json, :content_type => :json , :accept => :json)
    logger.debug "THIS IS THE #{response}"
  end

end
