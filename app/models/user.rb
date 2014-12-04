class User < ActiveRecord::Base
	validates :email, :username, presence: true, uniqueness: true
	validates :password_digest, presence: { message: "Password can't be blank" }
  validates :session_token, presence: true
	# validation will not run if the password attribute is blank
  validates :password, length: { minimum: 6, allow_nil: true }
	
	after_initialize :ensure_session_token

  has_many(:submitted_urls, class_name: 'ShortenedUrl',
           foreign_key: :submitter_id, primary_key: :id, dependent: :destroy)

  has_many(:visits, class_name: "Visit", foreign_key: :visitor_id,
            primary_key: :id)
  has_many :visited_urls, -> { distinct }, through: :visits, source: :shortened_url

  def recent_submissions
    submitted_urls.where(created_at: 1.minute.ago..Time.now)
  end
	
  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

	# reset user.session_token in database
  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
    self.session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

	# validates by email and password; else, nil
	def self.find_by_credentials(email, password)
		user = User.find_by_email(email)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  private

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end
	
end
