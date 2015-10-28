class AddUserToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :creator_id, :integer
    add_index :answers, :creator_id
  end
end
