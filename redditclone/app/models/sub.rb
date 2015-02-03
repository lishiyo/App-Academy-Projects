class Sub < ActiveRecord::Base
  validates :title, :user_id, presence: true

  belongs_to(
    :moderator,
    class_name: 'User',
    foreign_key: :user_id
  )

  has_many :post_subs, class_name: "PostSub", foreign_key: :sub_id, inverse_of: :sub
  has_many :posts, through: :post_subs, source: :post

end
