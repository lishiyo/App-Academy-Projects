class Sub < ActiveRecord::Base
  validates :title, :user_id, presence: true

  has_many(
    :posts,
    class_name: 'Post',
    foreign_key: :sub_id,
    dependent: :destroy
  )

  belongs_to(
    :moderator,
    class_name: 'User',
    foreign_key: :user_id
  )

  has_many :post_subs, class_name: "PostSub", foreign_key: :sub_id, inverse_of: :sub

end
