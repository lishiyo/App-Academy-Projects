class CreateUserFeedFavorites < ActiveRecord::Migration
  def change
    create_table :user_feed_favorites do |t|
      t.integer :user_id
      t.integer :feed_id

      t.timestamps
    end

    add_index :user_feed_favorites, :user_id
    add_index :user_feed_favorites, :feed_id
  end
end
