class User < ActiveRecord::Base

  attr_reader :password
  attr_accessor :curr_session_token
  # triggered for each object that is found and instantiated by a finder
  after_initialize :ensure_session_token

  validates :user_name, :password_digest, :session_token, presence: true

  has_many(:cats,
  :class_name => 'Cat',
  :foreign_key => :owner_id,
  :inverse_of => :owner,
  :dependent => :destroy
  )

  has_many(
  :rental_requests,
  :class_name => "CatRentalRequest",
  :foreign_key => :user_id,
  :inverse_of => :requester,
  :dependent => :destroy)

  has_many :session_tokens, class_name: "UserSessionOwnership",
    foreign_key: :user_id, inverse_of: :user, dependent: :destroy

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

  # logout! => set @curr_session_token = nil on this browser
  # returns session_token from new SessionTokenOwnership object
  def set_curr_session_token
    @curr_session_token ||= persisted_token.session_token
  end

  # after log-in, persist new session_token to database
  def persisted_token
    self.session_tokens.create!(session_token: self.session_token)
  end

  private

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

end
