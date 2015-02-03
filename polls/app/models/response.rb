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
  #  self.question.responses.where.not(id: id)
    #
    # Response.find_by_sql("
    #   SELECT DISTINCT
    #     r2.*
    #   FROM
    #     responses AS r
    #   INNER JOIN
    #     (
    #       SELECT
    #         as0.id AS as_id, q.id AS q_id
    #       FROM
    #         answer_choices AS as0
    #       INNER JOIN
    #         questions AS q ON q.id = as0.question_id
    #       WHERE
    #         as0.id = #{answer_choice_id}
    #     ) AS as2 ON r.answer_choice_id = as2.as_id
    #   INNER JOIN
    #     answer_choices AS as3 ON as3.question_id = as2.q_id
    #   INNER JOIN
    #     responses AS r2 ON r2.answer_choice_id = as3.id
    #   WHERE
    #     #{self.id} IS NULL OR r2.id != #{self.id}")


    Response
      .joins('JOIN answer_choices AS as0 ON responses.answer_choice_id = as0.id')
      .joins('JOIN questions AS q ON q.id = as0.question_id')
      .joins('JOIN answer_choices AS as3 ON as3.question_id = q.id')
      .joins('JOIN responses AS r2 ON r2.answer_choice_id = as3.id')
      .select('r2.*').distinct
      .where('as0.id = ?', answer_choice_id)
      .where('? IS NULL OR r2.id != ?', self.id, self.id)
    
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
