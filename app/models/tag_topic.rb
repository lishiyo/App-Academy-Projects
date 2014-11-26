class TagTopic < ActiveRecord::Base
  validates :topic, presence: true, uniqueness: true

  has_many(:taggings, class_name: 'Tagging', foreign_key: :tag_id,
            primary_key: :id)
  has_many :shortened_urls, through: :taggings, source: :shortened_url

  def self.topics
    TagTopic.all
  end

  def most_popular_urls(n)
    ShortenedUrl.joins(:visits)
                .group('shortened_urls.id')
                .order('COUNT(*) DESC')
                .map(&:long_url)
  end

end
