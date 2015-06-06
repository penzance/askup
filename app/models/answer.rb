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

  # for now, this method requires a hash representation of the user ID and role so the backend
  #   can authorize the update; this warrants an attempt to refactor / redesign
  def update(user_hash)
    json_payload_hash = Hash.new
    json_payload_hash['answer'] = self.as_json(:only => [:text])
    json_payload_hash['user'] = user_hash
    json_payload = ActiveSupport::JSON.encode(json_payload_hash)
    logger.debug "payload to update question: #{json_payload}"
    response = RestClient.patch("#{ENV['qm_api_url']}questions/#{self.question_id}/answers/#{self.id}", json_payload, :content_type => :json , :accept => :json)
    logger.debug "answer.update received the following response from the question market: #{response}"
  end

end
