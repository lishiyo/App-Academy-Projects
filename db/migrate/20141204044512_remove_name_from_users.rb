class RemoveNameFromUsers < ActiveRecord::Migration
  def change
		remove_column :users, :name
		add_column :users, :username, :string
		add_column :users, :password_digest, :string, presence: true
  end
end
