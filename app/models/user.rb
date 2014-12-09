class User < ActiveRecord::Base
  validates :username, :password_digest, :session_token, presence: true
  validates :username, uniqueness: true
  validates :password, length: {minimum: 6}, allow_nil: true

  after_initialize :ensure_session_token

  attr_reader :password

  has_many(
    :posts,
    class_name: 'Post',
    foreign_key: :user_id,
    inverse_of: :author,
    dependent: :destroy
  )

  has_many(
    :subs,
    class_name: 'Sub',
    foreign_key: :user_id,
    inverse_of: :moderator
  )

  has_many :comments, class_name: 'Comment', foreign_key: :user_id


  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def reset_session_token
    self.session_token = self.class.generate_session_token
    self.save!
    self.session_token
  end

  def self.find_by_credentials(username, password)
    user = User.find_by_username(username)

    return nil if user.nil?
    return nil unless user.is_password?(password)

    user

  end

  private
  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

end
