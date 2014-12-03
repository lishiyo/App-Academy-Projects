class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name, presence: true
      t.integer :owner_id, presence: true

      t.timestamps
    end

    add_index :groups, :owner_id 
  end
end
