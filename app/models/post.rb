class Post < ActiveRecord::Base
  belongs_to(
    :sub,
    class_name: 'Sub',
    foreign_key: :sub_id
  )

  belongs_to(
    :author,
    class_name: 'User',
    foreign_key: :user_id
  )

  validates :title, :url, :sub, :author, presence: true


end
