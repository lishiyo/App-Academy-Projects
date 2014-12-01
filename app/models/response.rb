class Response < ActiveRecord::Base

  validates :respondent_id, presence: true
  validates :answer_choice_id, presence: true
  validate :respondent_has_not_already_answered_question
  validate :author_cannot_respond_to_own_poll

  belongs_to :answer_choice, class_name: "AnswerChoice", foreign_key: :answer_choice_id
  belongs_to :respondent, class_name: "User", foreign_key: :respondent_id

  has_one :question, through: :answer_choice, source: :question


  #  other Response objects for the same Question
  def sibling_responses
    self.question.responses.where.not(id: nil).where.not(id: id)
  end


  private

  def respondent_has_not_already_answered_question
    if sibling_responses.exists?(respondent_id: self.respondent_id)
      errors[:respondent] << "Can't have already answered question"
    end
  end

  def author_cannot_respond_to_own_poll
    if self.answer_choice.question.poll.author_id == respondent_id
      errors[:respondent] << "Author cannot respond to own poll"
    end
  end

end
