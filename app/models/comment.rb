class Comment < ActiveRecord::Base

  belongs_to :commentable, polymorphic: true
  validates :commentable_id, :text, presence: true
  
end
