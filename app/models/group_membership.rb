class GroupMembership < ActiveRecord::Base
  validates :contact_id, presence: true, uniqueness: {scope: :group_id}
  validates :group_id, presence: true
  validate :group_owner_owns_contact

  belongs_to :group
  belongs_to :contact
  has_one :group_owner, through: :group, source: :owner

  private

  def group_owner_owns_contact
    if !group_owner.all_contacts.include?(contact)
      errors[:contact_id] << "doesn't belong to you."
    end
  end
end
