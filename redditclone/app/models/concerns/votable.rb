module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  # post.karma_score, comment.karma_score
  def karma_score
    self.class.includes(:votes)
      .where('votes.votable_type = ? AND votes.votable_id = ?', self.class.name, self.id)
      .sum(:value)
  end

end
