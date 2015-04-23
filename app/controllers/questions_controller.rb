class QuestionsController < ApplicationController
  include QuestionsHelper
  authorize_resource

  before_action :authenticate_user!

  def index
    @questions = get_question_list().sort_by{|hash| hash['created_at']}.reverse!
    @my_questions = @questions.select{|question| question["user_id"] == current_user.id}
    @question_limitations = ENV["limit_question_index_to_users_questions_only"]
  end

  def show
    @questions = get_question_list()
    @question_id = params[:id]
    @question = @questions[(params[:id]).to_i - 1]["text"]

    logger.debug "QUESTION's type in question's show: #{@questions[(params[:id]).to_i - 1].class}"

    @answers = @questions[(params[:id]).to_i - 1]["answers"]
    @answer = Answer.new
  end

  def new
    @question = Question.new
    @question.answers.build
    logger.debug "@question from new is #{@question}"
  end

  def create
    question = Question.new(params.require(:question)
      .permit(:text,
        answers_attributes:[:text]))

    logger.debug "QUESTION's type in question's create: #{question.class}"

    question.user_id = current_user.id
    question.post_question(question)

    logger.debug "@QUESTION's type in question's destroy: #{@question.class}"

    redirect_to new_question_path, notice: "Your question has been submitted! Enter another if you would like."
  end

  # def show
  #   @questions = get_question_list()
  #   @question_id = params[:id]
  #   @question = @questions[(params[:id]).to_i - 1]["text"]
  #   @answers = @questions[(params[:id]).to_i - 1]["answers"]
  #   @answer = Answer.new
  # end


  def destroy
    logger.debug "PARAMS in question's destroy: #{params}"
    @questions = get_question_list()
    @question_id = params[:id]
    @question = @questions[(params[:id].to_i-1)]

    logger.debug "@QUESTIONS LIST TYPE in question's destroy: #{@questions.class}"
    logger.debug "@QUESTIONS LIST'S ATTRIBUTES in question's destroy: #{@questions.class}"
    logger.debug "@QUESTION in question's destroy: #{@question}"
    logger.debug "@QUESTION's type in question's destroy: #{@question.class}"

    destroy_question(@question)
    redirect_to questions_path
  end


  def feedback
    user_knowledge = (params[:correct] == "yes" ? "knew" : "didn't know")
    analyzer.info("User #{current_user.id} #{user_knowledge} question #{params[:id]}")
    respond_to do |format|
        format.js { render :nothing => true }
    end
  end
  

end
