class AnswersController < ApplicationController
  include AnswersHelper
  include QuestionsHelper
  def new
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build

  end
  
  def create
    answer = Answer.new(params.require(:answer)
      .permit(:text, :question_id))
    add_answer(answer)
    @question_id = params[:question_id]
    @answer = Answer.new
    @questions = get_question_list()
    @question = @questions[(params[:question_id]).to_i - 1]["text"]
    @answers = @questions[(params[:question_id]).to_i - 1]["answers"]
    render "questions/show"
    
  end
end
