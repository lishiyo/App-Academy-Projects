class UserFeedFavorite < ActiveRecord::Base

  belongs_to :feed
  belongs_to :fav_user, class_name: "User", foreign_key: :user_id

  validates :feed, uniqueness: { scope: :fav_user }

end
