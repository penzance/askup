class FixQsetColumnNameInQuestions < ActiveRecord::Migration
  def change
    rename_column :questions, :question_group_id, :qset_id
  end
end
