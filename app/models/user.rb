class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true

  has_many :contacts, inverse_of: :owner, dependent: :destroy
  has_many :contact_shares, inverse_of: :user
  has_many :shared_contacts, through: :contact_shares, source: :contact
  has_many :comments, as: :commentable
end
