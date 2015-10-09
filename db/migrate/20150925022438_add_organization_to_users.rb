class AddOrganizationToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :organization, :string, :default => "college"
  end
end
