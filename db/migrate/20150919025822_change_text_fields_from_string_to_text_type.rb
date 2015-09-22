class ChangeTextFieldsFromStringToTextType < ActiveRecord::Migration
  # Fields with type :string only store 255 characters by default in postgres,
  # so we want to change them to type :text in order to store longer questions
  # and answers.
  def up
    change_column :answers, :text, :text
    change_column :questions, :text, :text
  end
  def down
    change_column :answers, :text, :string
    change_column :questions, :text, :string
  end
end
