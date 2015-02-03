class Goal < ActiveRecord::Base

  validates :name, :content, :user, presence: true
  validates :completed?, inclusion: [true, false]
  validates :public?, inclusion: [true, false]

  belongs_to :user

  def past_due?
    self.deadline < Date.today
  end

end
