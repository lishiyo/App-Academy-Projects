class User < ActiveRecord::Base
  attr_reader :password
  validates :username, :password_digest, :session_token, presence: true
  validates :password, length: { minimum: 5, allow_nil: true }

  after_initialize :ensure_session_token

  has_many :feeds, inverse_of: :user, dependent: :destroy
  # has_many :favorited_feeds, through: :feeds, source: :favoritable, source_type: 'Feed'

  has_many :entries, through: :feeds, source: :entries
  # has_many :favorited_entries, through: :entries, source: :favoritable, source_type: "Entry"

  has_many :feed_favs, class_name: "UserFeedFavorite", foreign_key: :user_id, primary_key: :id
  has_many :favorited_feeds, through: :feed_favs, source: :feed

  def self.generate_session_token
    SecureRandom.urlsafe_base64
  end

  def reset_session_token
    self.session_token = User.generate_session_token
    self.save!

    self.session_token
  end

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    return nil unless user
    is_password?(password) ? user : nil
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  private

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end
end
