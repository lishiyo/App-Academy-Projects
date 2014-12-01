class Question < ActiveRecord::Base

  validates :poll_id, presence: true

  has_many :answer_choices, class_name: "AnswerChoice", foreign_key: :question_id
  belongs_to :poll, class_name: "Poll", foreign_key: :poll_id
  has_many :responses, through: :answer_choices, source: :responses

  

end
