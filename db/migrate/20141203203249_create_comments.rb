class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :text, presence: true
      t.references :commentable, polymorphic: true
      t.timestamps
    end
  end
end
