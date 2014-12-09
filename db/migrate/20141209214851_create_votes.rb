class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :value, null: false
      t.references :votable, polymorphic: true, null: false

      t.timestamps
    end

    add_index :votes, [:votable_type, :votable_id]
  end
end
