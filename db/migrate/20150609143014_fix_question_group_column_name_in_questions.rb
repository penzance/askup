class FixQuestionGroupColumnNameInQuestions < ActiveRecord::Migration
  def change
    rename_column :questions, :group_id, :question_group_id
  end
end
