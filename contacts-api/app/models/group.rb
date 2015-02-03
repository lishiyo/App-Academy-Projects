class Group < ActiveRecord::Base
  validates :owner_id, :name, presence: true

  belongs_to :owner, class_name: "User", foreign_key: :owner_id
  has_many :group_memberships
  has_many :contacts, through: :group_memberships, source: :contact
end
