class Question < ActiveRecord::Base
  has_many :answers
  belongs_to :user
  accepts_nested_attributes_for :answers

  def post_question question
    json = question.to_json(:include => :answers)
    response = RestClient.post(ENV["qm_api_url"] + 'questions', json, :content_type => :json , :accept => :json)
    logger.debug "RESPONSE for question from post_question: #{response}"
  end

  # for now, this method requires a hash representation of the user ID and role so the backend
  #   can authorize the update; this warrants an attempt to refactor / redesign
  #   this is also very similar to other model update methods, may also be refactored to be more DRY
  def update(user_hash)
    json_payload_hash = Hash.new
    json_payload_hash['question'] = self.as_json(:only => [:text, :user_id])
    json_payload_hash['user'] = user_hash
    json_payload = ActiveSupport::JSON.encode(json_payload_hash)
    logger.debug "payload to update question: #{json_payload}"
    response = RestClient.patch("#{ENV['qm_api_url']}questions/#{self.id}", json_payload, :content_type => :json , :accept => :json)
    logger.debug "question.update received the following response from the question market: #{response}"
  end

end