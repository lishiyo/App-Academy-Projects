include ActionView::Helpers::DateHelper

class Cat < ActiveRecord::Base
  COLORS = %w(black white tortoiseshell tabby orange brown)

  validates :sex, inclusion: { in: %w(M F), message: "%{value} is not a valid gender"}
  validates :color, inclusion: COLORS
  validates :name, presence: true

  def age
    "#{time_ago_in_words(self.birth_date)} old"
  end


end
