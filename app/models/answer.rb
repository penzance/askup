class Answer < ActiveRecord::Base
  belongs_to :question
  validates_length_of :answer, :minimum => 1           # more than 8 characters

  def respond(response)
    question = Question.find(self.question_id)
    email = User.find(current_user.id).email
    analyzer.info(
      "RESPONSE for user #{email} on question #{question}: #{response}.
      Their answer was #{self.text}")
  end

end
