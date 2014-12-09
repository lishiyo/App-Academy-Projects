class PostSub < ActiveRecord::Base

  belongs_to(
    :sub,
    class_name: 'Sub',
    foreign_key: :sub_id
  )

  belongs_to :post, class_name: "Post", foreign_key: :post_id

  # With inverse of, validate on the model instance and NOT the id column
  validates :post, :sub_id, presence: true
  validates :post, uniqueness: {scope: :sub_id}


end
