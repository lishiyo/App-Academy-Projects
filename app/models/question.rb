class Question < ActiveRecord::Base

  validates :poll_id, presence: true

  has_many :answer_choices, class_name: "AnswerChoice", foreign_key: :question_id
  belongs_to :poll, class_name: "Poll", foreign_key: :poll_id
  has_many :responses, through: :answer_choices, source: :responses
  # self.responses = self.answer_choices => answer_choice.responses


  def results
    res = Hash.new(0)
    # N+1 query
    # self.answer_choices.map { |choice| res[choice.text] = choice.responses.count }

    # pre-fetch with includes
    # all_choices = self.answer_choices.includes(:responses)
    # all_choices.map{|choice| res[choice.text] = choice.responses.length }

    # SQL
    # SELECT answer_choices.*, COUNT(responses.id) AS res_count
    # FROM answer_choices
    # LEFT JOIN responses ON responses.answer_choice_id = answer_choices.id
    # WHERE answer_choices.question_id = ?
    # GROUP BY answer_choices.id

    all_res = self.answer_choices
      .select('answer_choices.*, COUNT(responses.id) AS res_count')
      .joins('LEFT OUTER JOIN responses ON responses.answer_choice_id = answer_choices.id')
      .group('answer_choices.id')

    all_res.map{|answer_choice| res[answer_choice.text] = answer_choice.res_count }

    res
  end

end
