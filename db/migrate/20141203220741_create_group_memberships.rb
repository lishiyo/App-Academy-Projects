class CreateGroupMemberships < ActiveRecord::Migration
  def change
    create_table :group_memberships do |t|
      t.integer :group_id, presence: true
      t.integer :contact_id, presence: true

      t.timestamps
    end

    add_index :group_memberships, :group_id
    add_index :group_memberships, :contact_id
    add_index :group_memberships, [:contact_id, :group_id], unique: true
  end
end
