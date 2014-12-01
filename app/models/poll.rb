class Poll < ActiveRecord::Base

  validates :author_id, presence: true
  
  belongs_to :author, class_name: "User", foreign_key: :author_id
  # belongs_to :author, inverse_of: :authored_polls
  has_many :questions, class_name: "Question", foreign_key: :poll_id

end
