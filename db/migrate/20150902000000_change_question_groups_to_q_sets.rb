class ChangeQuestionGroupsToQsets < ActiveRecord::Migration
  def change
    rename_table :question_groups, :qsets
  end
end
