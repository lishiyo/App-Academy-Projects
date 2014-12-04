class AddSessionTokentoUsers < ActiveRecord::Migration
	
  def change
		add_column :users, :session_token, :string, unique: true
  end
	
end
