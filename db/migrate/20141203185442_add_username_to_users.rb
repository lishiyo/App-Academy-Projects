class AddUsernameToUsers < ActiveRecord::Migration
  def up
    remove_column :users, :name
    remove_column :users, :email
    add_column :users, :username, :string, uniqueness: true, presence: true
    add_index :users, :username, unique: true
  end

  def down
    add_column :users, :name, :string
    add_column :users, :email, :string
    remove_column :users, :username
    remove_index :users, :username
  end
end
