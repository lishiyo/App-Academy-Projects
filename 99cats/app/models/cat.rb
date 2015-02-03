include ActionView::Helpers::DateHelper

class Cat < ActiveRecord::Base

  COLORS = ["brown", "tabby", "tortoiseshell", "calico", "striped", "black", "white"]

  validates :name, presence: true
  validates :color, inclusion: { in: COLORS, message: "%{value} is not a valid color" }
  validates :sex, presence: true, inclusion: { in: %w(M F) }

  def age
    time_ago_in_words(self.birth_date)
  end

  has_many(:cat_rental_requests, :inverse_of => :cat, :dependent => :destroy)

  belongs_to(
  :owner,
  :class_name => 'User',
  :foreign_key => :user_id,
  :primary_key => :id)
end
