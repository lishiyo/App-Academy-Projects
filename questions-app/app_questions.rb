require 'singleton'
require 'sqlite3'

class Class

  def my_attr_accessor(*args)

    args.each do |arg|
      self.class_eval("def #{arg};@#{arg};end")
      self.class_eval("def #{arg}=(val);@#{arg}=val;self.save;end")
    end

  end

end

class QuestionDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')

    self.results_as_hash = true
    self.type_translation = true
  end
end

module Createable
  def self.new_instance(*args)
    params = {}
    test = self.new
    test.instance_variables.each_with_index do |var, i|
      next if var == :@id
      new_var = var[1..-1]
      params[new_var] = args[i-1]
    end

    new_self = self.new(params)
    new_self.create
    new_self
  end
end

module Saveable

  def save
    self.id.nil? ? create : update
  end

  def to_table_name
    name = self.class.to_s.downcase
    if name[-1] == 'y'
     name[0..-2] + "ies"
    else
     name + "s"
    end
  end


  def create
    params = {}
    self.instance_variables.each do |var|
      new_var = var[1..-1].to_sym
      params[new_var] = self.send(new_var)
    end

    QuestionDatabase.instance.execute(<<-SQL)
      INSERT INTO
        #{to_table_name} (#{params.keys.join(",")})
      VALUES
        (#{params.values.map{|el| "'#{el}'"}.join(",")})
    SQL
    @id = QuestionDatabase.instance.last_insert_row_id
  end

  def update
    params = {}
    self.instance_variables.each do |var|
      new_var = var[1..-1].to_sym
      params[new_var] = self.send(new_var)
    end

    QuestionDatabase.instance.execute(<<-SQL)
      UPDATE
        #{to_table_name}
      SET
        #{params.map { |k,v| "#{k} = '#{v}'"}.join(", ")}
      WHERE
        id = #{self.id}
    SQL
  end

end

#---------------------------------------------------------------
#---------------------------------------------------------------
class User

  include Saveable
  def self.find_by_id(id)
    results = QuestionDatabase.instance.execute(<<-SQL,id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL

    results.nil? ? nil : User.new(results.first)
  end

  def self.find_by_name(fname, lname)
    results = QuestionDatabase.instance.execute(<<-SQL, fname: fname, lname: lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = :fname AND lname = :lname
    SQL

    results.nil? ? nil : User.new(results.first)
  end

  my_attr_accessor :id, :fname, :lname

  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions
    Question.find_by_user_id(self.id)
  end

  def authored_replies
    Reply.find_by_user_id(self.id)
  end

  def followed_questions
    QuestionFollower.followed_questions_for_user_id(self.id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(self.id)
  end

  def average_karma
    # returns total num of questions asked by user and
    # total number of likes on those questions
    results = QuestionDatabase.instance.execute(<<-SQL, self.id)
      SELECT
      (COUNT(question_likes.id) /
      CAST(COUNT(DISTINCT(questions.id)) AS FLOAT)) avg
      FROM
        questions
      LEFT OUTER JOIN
        question_likes
      ON
        questions.id = question_likes.question_id
      WHERE
        questions.user_id = ?
    SQL
    p results
    results.first['avg']
  end

end
#---------------------------------------------------------------
#---------------------------------------------------------------
class Question

  include Saveable
  def self.find_by_id(id)
    results = QuestionDatabase.instance.execute(<<-SQL,id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    results.nil? ? nil : Question.new(results.first)
  end

  def self.find_by_user_id(user_id)
    results = QuestionDatabase.instance.execute(<<-SQL,user_id)
      SELECT
        *
      FROM
        questions
      WHERE
        user_id = ?
    SQL

    return nil if results.nil?

    results.map do |result|
      Question.new(result)
    end
  end

  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked(n)
  end

  my_attr_accessor :id, :title, :body, :user_id

  def initialize(options = {})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end

  def author
    User.find_by_id(self.user_id)
  end

  def replies
    Reply.find_by_question_id(self.id)
  end

  def followers
    QuestionFollowers.followers_for_question_id(self.id)
  end

  def likers
    QuestionLike.likers_for_question_id(self.id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(self.id)
  end


end
#---------------------------------------------------------------
#---------------------------------------------------------------
class QuestionFollower


  def self.find_by_id(id)
    results = QuestionDatabase.instance.execute(<<-SQL,id)
      SELECT
        *
      FROM
        questionfollowers
      WHERE
        id = ?
    SQL

    results.nil? ? nil : QuestionFollower.new(results.first)
  end

  # return an array of User objects
  def self.followers_for_question_id(question_id)
    results = QuestionDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        questionfollowers
      JOIN
        users
      ON
        questionfollowers.user_id = users.id
      WHERE
        questionfollowers.question_id = ?
    SQL

    return nil if results.nil?
    results.map{ |res| User.new(res) }
  end

  # return an array of Question objects
  def self.followers_for_user_id(user_id)
    results = QuestionDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        questionfollowers
      JOIN
        questions
      ON
        questionfollowers.question_id = questions.id
      WHERE
        questionfollowers.user_id = ?
    SQL

    return nil if results.nil?
    results.map{ |res| Question.new(res) }
  end

  def self.most_followed_questions(n)
    results = QuestionDatabase.instance.execute(<<-SQL, n: n)
      SELECT
        questions.*
      FROM
        questionfollowers
      JOIN
        questions ON questionfollowers.question_id = questions.id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(questionfollowers.user_id)
      LIMIT :n;
    SQL

    return nil if results.nil?
    results.map { |result| Question.new(result) }
  end

  attr_accessor :id, :user_id, :question_id

  def initialize(options ={})
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

end
#---------------------------------------------------------------
#---------------------------------------------------------------
class Reply

  include Saveable
  extend Createable
  def self.new_instance(*args)
    params = {}
    test = self.new
    args.unshift(nil)
    test.instance_variables.each_with_index do |var, i|
      new_var = var[1..-1]
      params[new_var] = args[i]
    end

    new_self = self.new(params)
    p new_self
    p params
    new_self.create
    new_self
  end


  def self.find_by_id(id)
    results = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL

    results.nil? ? nil : Reply.new(results.first)
  end

  def self.find_by_question_id(question_id)
    results = QuestionDatabase.instance.execute(<<-SQL,question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL

    return nil if results.nil?

    results.map do |result|
      Reply.new(result)
    end
  end

  def self.find_by_user_id(user_id)
    results = QuestionDatabase.instance.execute(<<-SQL,user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL

    return nil if results.nil?

    results.map do |result|
      Reply.new(result)
    end
  end


  my_attr_accessor :id, :body, :question_id, :user_id, :parent_id

  def initialize(options = {})
    @id = options['id']
    @body = options['body']
    @question_id = options['question_id']
    @user_id = options['user_id']
    @parent_id = options['parent_id']
  end

  def author
    User.find_by_id(self.user_id)
  end

  def question
    Question.find_by_id(self.question_id)
  end

  def parent_reply
    Reply.find_by_id(self.parent_id)
  end

  def child_replies
    results = QuestionDatabase.instance.execute(<<-SQL, self.id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = ?
    SQL

    return nil if results.nil?
    results.map{|res| Reply.new(res) }
  end

end
#---------------------------------------------------------------
#---------------------------------------------------------------
class QuestionLike

  def self.find_by_id(id)
    results = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
    SQL

    QuestionLike.new(results.first)
  end

  def self.likers_for_question_id(question_id)
    results = QuestionDatabase.instance.execute(<<-SQL,question_id)
      SELECT
        users.*
      FROM
        question_likes
      JOIN
        users ON question_likes.user_id = users.id
      WHERE
        question_likes.question_id = ?
    SQL
    results.map { |result| User.new(result) }
  end

  def self.num_likes_for_question_id(question_id)
    results = QuestionDatabase.instance.execute(<<-SQL,question_id)
      SELECT
        COUNT(users.id) num_likes
      FROM
        question_likes
      JOIN
        users ON question_likes.user_id = users.id
      WHERE
        question_likes.question_id = ?
    SQL
    results.first['num_likes']
  end

  def self.liked_questions_for_user_id(user_id)
    results = QuestionDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        question_likes
      JOIN
        questions ON question_likes.question_id = questions.id
      WHERE
        question_likes.user_id = ?
    SQL

    results.map{ |res| Question.new(res) }
  end

  def self.most_liked_questions(n)
    results = QuestionDatabase.instance.execute(<<-SQL, n: n)
      SELECT
        questions.*
      FROM
        question_likes
      JOIN
        questions ON question_likes.question_id = questions.id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(question_likes.user_id)
      LIMIT :n;
    SQL

    results.map { |result| Question.new(result) }
  end

  attr_accessor :id, :question_id, :user_id

  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

end
