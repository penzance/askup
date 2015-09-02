class QsetsController < ApplicationController
  authorize_resource

  # handles the request to save a new qset
  # (called from the new qset modal)
  def create
    create_group_params = params.permit(:name, :parent_id)
    qset = Qset.new(create_group_params)
    qset.save
    redirect_to questions_path(qset_id: qset.id),
                notice: "Qset '#{qset.name}' created."
  end

  # handles the request to update an existing qset
  # (called from the edit qset modal)
  def update
    # note: parent_id is not changeable via this UI
    update_group_params = params.permit(:id, :name)
    qset = Qset.find(params[:id])
    qset.update(update_group_params)
    msg = "Qset '#{qset.name}' saved."
    redirect_to questions_path(qset_id: qset.id), notice: msg
  end

  def destroy
    delete_group_params = params.permit(:id)
    qset = Qset.find(params[:id])
    parent_id = qset.parent_id
    if qset.destroy
      redirect_to questions_path(qset_id: parent_id),
                  notice: "Qset deleted."
    else
      redirect_to questions_path(qset_id: params[:id]),
                  alert: "Qset could not be deleted."
    end
  end
end
