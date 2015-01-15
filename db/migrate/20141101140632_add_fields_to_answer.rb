class AddFieldsToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :question_id, :int
    add_column :answers, :text, :string
  end
end
