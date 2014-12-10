class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :content, null: false
      t.string :name, null: false
      t.date :deadline
      t.integer :user_id, null: false
      t.boolean :public, default: false

      t.timestamps
    end
    
    add_index :goals, :user_id
  end
end
