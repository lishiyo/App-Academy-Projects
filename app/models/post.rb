class Post < ActiveRecord::Base
  # belongs_to(
  #   :sub,
  #   class_name: 'Sub',
  #   foreign_key: :sub_id
  # )

  belongs_to(
    :author,
    class_name: 'User',
    foreign_key: :user_id
  )


  validates :title, :url, :author, presence: true
  has_many :post_subs, class_name: "PostSub",
    foreign_key: :post_id, inverse_of: :post, dependent: :destroy
  # cross posts
  has_many :subs, through: :post_subs, source: :sub


end
