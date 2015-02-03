class AddUserId < ActiveRecord::Migration
  def change
    add_column :feeds, :user_id, :integer
    add_index :feeds, :user_id
  end
end
