class Answer < ActiveRecord::Base
  belongs_to :question

  def respond(response)
    question = Question.find(self.question_id)
    email = User.find(current_user.id).email
    analyzer.info(
      "RESPONSE for user #{email} on question #{question}: #{response}.
      Their answer was #{self.text}")
  end

end
