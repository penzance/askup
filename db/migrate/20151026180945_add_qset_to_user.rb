class AddQsetToUser < ActiveRecord::Migration
  def change
  	add_column :users, :org_id, :integer
  	add_index :users, :org_id
  end
end
