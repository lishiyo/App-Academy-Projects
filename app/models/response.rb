class Response < ActiveRecord::Base

  validates :respondent_id, presence: true
  validates :answer_choice_id, presence: true
  validate :respondent_has_not_already_answered_question
  validate :does_not_respond_to_own_poll

  belongs_to :answer_choice, class_name: "AnswerChoice", foreign_key: :answer_choice_id
  belongs_to :respondent, class_name: "User", foreign_key: :respondent_id

  has_one :question, through: :answer_choice, source: :question


  #  other Response objects for the same Question
  def sibling_responses
  #  self.question.responses.where.not(id: nil).where.not(id: id)

    Response.find_by_sql("
      SELECT
        r2.*
      FROM
        responses AS r
      INNER JOIN
        (
          SELECT
            as.*
          FROM
            answer_choices AS as
          INNER JOIN
            questions AS q ON q.id = as.question_id
          WHERE
            as.id = ?
        ) AS as2 ON r.answer_choice_id = as2.id
      INNER JOIN
        answer_choices AS as3 ON as3.id = as2.id
      INNER JOIN
        responses AS r2 ON r2.answer_choice_id = as3.id
      WHERE
        r2.id != ?
    ", answer_choice_id, id)
    #
    # Response.joins(answer_choice: :question)
    #   .where('answer_choices.id = ?', answer_choice_id)
    #   .joins(answer_choices: :responses)
    #   .where.not(id: nil).where.not(id: id)

  end


  private

  def respondent_has_not_already_answered_question
    if sibling_responses.exists?(respondent_id: self.respondent_id)
      errors[:respondent] << "Can't have already answered question"
    end
  end

  def does_not_respond_to_own_poll

    poll = Poll.joins(questions: :answer_choices ).where('answer_choices.id = ?', answer_choice_id).first

    if poll.author_id == respondent_id
      errors[:respondent] << "Author cannot respond to own poll"
    end
  end

end
