class Response < ActiveRecord::Base

  validates :respondent_id, presence: true
  validates :answer_choice_id, presence: true
  validate :respondent_has_not_already_answered_question

  belongs_to :answer_choice, class_name: "AnswerChoice", foreign_key: :answer_choice_id
  belongs_to :respondent, class_name: "User", foreign_key: :respondent_id

  has_one :question, through: :answer_choice, source: :question


  #  other Response objects for the same Question
  def sibling_responses
    self.question.responses
      .where('? IS NOT NULL AND responses.id != ?', self.id)
  end


  private

  def respondent_has_not_already_answered_question

  end
end
