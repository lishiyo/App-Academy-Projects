class ShortenedUrl < ActiveRecord::Base
  validates :submitter_id, presence: true
  validates :long_url, presence: true, length: { maximum: 1024 }
  validate :recent_submissions_cannot_be_more_than_five

  belongs_to(:submitter, :class_name => 'User', :foreign_key => :submitter_id,
             :primary_key => :id)

  has_many(:visits, class_name: "Visit", foreign_key: :shortened_url_id,
            primary_key: :id)
  has_many :visitors, -> { distinct }, through: :visits, source: :visitor
  has_many(:taggings, class_name: 'Tagging', foreign_key: :shortened_url_id,
            primary_key: :id)
  has_many :tag_topics, through: :taggings, source: :tag_topic

  def self.random_code
    code = SecureRandom::urlsafe_base64
    while ShortenedUrl.exists?(short_url: code)
      code = SecureRandom::urlsafe_base64
    end
    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    user.submitted_urls.create!(:long_url => long_url,
      :short_url => ShortenedUrl.random_code)
  end

  # total number of visits
  def num_clicks
    visits.count
  end

  # total number of unique visitors
  def num_uniques
    visitors.count
  end

  # total number of recent unique visits
  def recent_uniques
    visits.where(created_at: 10.minutes.ago..Time.now).distinct
  end

  private
  def recent_submissions_cannot_be_more_than_five
    if User.find_by_id(submitter_id).recent_submissions.count >= 5
      errors[:submissions] << "can't be more than five in one minute."
    end
  end
end
