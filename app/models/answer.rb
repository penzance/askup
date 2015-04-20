class Answer < ActiveRecord::Base
  belongs_to :question

  def add_answer answer
    json = answer.to_json
    response = RestClient.post(ENV["qm_api_url"] + "questions/#{params[:question_id]}/answers", json, :content_type => :json , :accept => :json)
    logger.debug "RESPONSE for answer from add_answer: #{response}"
  end

  def respond(response)
    question = Question.find(self.question_id)
    email = User.find(current_user.id).email
    analyzer.info(
      "RESPONSE for user #{email} on question #{question}: #{response}.
      Their answer was #{self.text}")
  end

  def destroy_answer answer
    json = answer.to_json

  end

end
