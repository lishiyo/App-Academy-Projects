class User < ActiveRecord::Base

  attr_reader :password
  # triggered for each object that is found and instantiated by a finder
  after_initialize :ensure_session_token

  validates :user_name, :password_digest, :session_token, presence: true

  has_many(:cats, :inverse_of => :owner)

  def self.find_by_credentials(user_name,password)
    user = User.find_by(:user_name => user_name)
    unless user
      return nil
    end
    if user.is_password?(password)
      user
    else
      return nil
    end
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end

  def password=(password)
    @password = password # set ivar to validate length of password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  private

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

end
