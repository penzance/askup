class QuestionGroupsController < ApplicationController
  require 'json'
  # Note: this is not authorized by cancancan as it is not an actual model/resource

  # handles the request to save a new question group to the backend (called from the new question group modal)
  def create
    group_params = params.permit(:name, :parent_id)
    question_group = {:name => group_params[:name], :parent_id => group_params[:parent_id]}
    response = RestClient.post(ENV["qm_api_url"] + 'question_groups',
                               question_group.to_json, :content_type => :json , :accept => :json)
    logger.debug "RESPONSE from question market: #{response}"
    response_hash = JSON.parse response
    redirect_to questions_path(question_group_id: response_hash['id']),
                notice: "Question group '#{response_hash['name']}' created."
  end

  # handles the request to update an existing question group to the backend (called from the edit question group modal)
  def update
    # note: parent_id is not changeable via this UI, so not permitted and not sent to Question Market
    group_params = params.permit(:id, :name)
    question_group = {:id => group_params[:id], :name => group_params[:name]}
    logger.debug "payload to update question group: #{question_group.to_json}"
    response = RestClient.patch("#{ENV['qm_api_url']}question_groups/#{group_params[:id]}",
                                question_group.to_json, :content_type => :json , :accept => :json)
    logger.debug "RESPONSE from question market: #{response}"
    response_hash = JSON.parse response
    msg = "Question group '#{response_hash['name']}' saved."
    redirect_to questions_path(question_group_id: response_hash['id']), notice: msg
  end

  def destroy
    unless current_user.role?(:admin)
      flash[:alert] = "Something went wrong; could not complete your request."
    else
      response = RestClient.delete("#{ENV['qm_api_url']}question_groups/#{params[:id]}",
                                   :content_type => :json , :accept => :json)
      logger.debug "Response from question market: #{response}"
      flash[:notice] = "Question group deleted."
    end
    redirect_to questions_path
  end
end
