class Comment < ActiveRecord::Base
  validates :author, :post, presence: true

  belongs_to :author, class_name: 'User', foreign_key: :user_id

  belongs_to :post, class_name: 'Post', foreign_key: :post_id

  has_many :child_comments, class_name: 'Comment', foreign_key: :parent_comment_id,
           inverse_of: :parent_comment

  belongs_to :parent_comment, class_name: 'Comment', foreign_key: :parent_comment_id

end
