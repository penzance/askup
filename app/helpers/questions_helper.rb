module QuestionsHelper
  require 'rest-client'
  require 'json'

  def get_question_list
    JSON.parse(RestClient.get(ENV["qm_api_url"] + "questions"))
  end



end

