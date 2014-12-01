class User < ActiveRecord::Base

  validates :username, presence: true, uniqueness: true

  has_many :authored_polls, class_name: "Poll", foreign_key: :author_id
  has_many :responses, class_name: "Response", foreign_key: :respondent_id

  def completed_polls
      # SQL
      # SELECT polls.*, COUNT(questions.id) AS questions_count, COUNT(res.id) as res_count
      # FROM polls INNER JOIN questions ON questions.poll_id = polls.id
      # INNER JOIN answer_choices ON answer_choices.question_id = questions.id
      # LEFT JOIN
      #   (SELECT *
      #     FROM responses
      #     WHERE responses.respondent_id = ?
      # ) AS res ON res.answer_choice_id = answer_choices.id
      # GROUP BY polls.id
      # HAVING COUNT(questions.id) = COUNT(res.id)

      # Poll.find_by_sql("
      #   SELECT polls.*, COUNT(DISTINCT questions.id) AS questions_count, COUNT(res.id) as res_count
      #   FROM polls INNER JOIN questions ON questions.poll_id = polls.id
      #   INNER JOIN answer_choices ON answer_choices.question_id = questions.id
      #   LEFT JOIN
      #     (SELECT *
      #       FROM responses
      #       WHERE responses.respondent_id = #{self.id}
      #   ) AS res ON res.answer_choice_id = answer_choices.id
      #   GROUP BY polls.id
      #   HAVING COUNT(DISTINCT questions.id) = COUNT(res.id)")

      Poll.select("polls.*, COUNT(DISTINCT questions.id) AS questions_count, COUNT(res.id) as res_count")
        .joins(questions: :answer_choices).joins("LEFT JOIN
        (SELECT *
        FROM responses
        WHERE responses.respondent_id = #{self.id}
        ) AS res ON res.answer_choice_id = answer_choices.id")
        .group("polls.id").having("COUNT(DISTINCT questions.id) = COUNT(res.id)")
  end

  def uncompleted_polls
    Poll.select("polls.*, COUNT(DISTINCT questions.id) AS questions_count, COUNT(res.id) as res_count")
      .joins(questions: :answer_choices).joins("LEFT JOIN
      (SELECT *
      FROM responses
      WHERE responses.respondent_id = #{self.id}
      ) AS res ON res.answer_choice_id = answer_choices.id")
      .group("polls.id").having("COUNT(DISTINCT questions.id) != COUNT(res.id) AND COUNT(res.id) > 0")
  end
end
