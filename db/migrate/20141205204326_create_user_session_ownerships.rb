class CreateUserSessionOwnerships < ActiveRecord::Migration
  def change
    create_table :user_session_ownerships do |t|
      t.integer :user_id, null: false
      t.string :session_token, null: false
      t.timestamps
    end

    add_index :user_session_ownerships, :user_id
  end
end
