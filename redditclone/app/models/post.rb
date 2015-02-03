class Post < ActiveRecord::Base
  include Votable

  belongs_to :author, class_name: 'User', foreign_key: :user_id

  validates :title, :url, :author, presence: true
  has_many :post_subs, class_name: "PostSub",
    foreign_key: :post_id, inverse_of: :post, dependent: :destroy
  # cross posts
  has_many :subs, through: :post_subs, source: :sub

  # has_many :comments, class_name: 'Comment', foreign_key: :post_id

  def comments
    Comment.includes(:author).includes(:child_comments).where(post_id: self.id)
  end

  # returns hash where keys are parent_ids
  def comments_by_parent_id
    hash = Hash.new { |h, k| h[k] = Array.new }
    self.comments.each do |comment| # comment_hash is a comment object
      parent_id = comment.parent_comment_id
      hash[parent_id] << comment
    end

    hash
  end

end
