class Visit < ActiveRecord::Base
  validates :shortened_url_id, presence: true
  validates :visitor_id, presence: true

  belongs_to(:shortened_url, class_name: "ShortenedUrl",
              foreign_key: :shortened_url_id, primary_key: :id)
	# SELECT * FROM shortened_urls WHERE shortened_urls.id = self.shortened_url_id
  belongs_to(:visitor, class_name: "User", foreign_key: :visitor_id,
              primary_key: :id)
	# SELECT * FROM users WHERE users.id = self.visitor_id

  def self.record_visit!(user, shortened_url)
    Visit.create!(visitor_id: user.id, shortened_url_id: shortened_url.id)
  end

end
