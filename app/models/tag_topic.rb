class TagTopic < ActiveRecord::Base
  validates :topic, presence: true, uniqueness: true

  has_many(:taggings, class_name: 'Tagging', foreign_key: :tag_id,
            primary_key: :id)
  has_many :shortened_urls, through: :taggings, source: :shortened_url

  def self.topics
    TagTopic.all
  end
	
	def most_popular_for_tag
		shortened_urls.joins('LEFT OUTER JOIN visits ON visits.shortened_url_id = shortened_urls.id').group('shortened_urls.id').order('COUNT(visits.*) DESC')    
		# shortened_urls.sort_by{|su| su.visits.count }.reverse
		# The sort_by hits each of the shortened_urls again (N+1 queries)
	end

  def TagTopic.most_popular_urls(n)
    ShortenedUrl.joins(:visits).group('shortened_urls.id').order('COUNT(*) DESC').limit(n)
  end

end
