class Vote < ActiveRecord::Base

  validates :value, :votable_id, :votable_type, presence: true
  validates :value, inclusion: [1, -1]

  belongs_to :votable, polymorphic: true

end
