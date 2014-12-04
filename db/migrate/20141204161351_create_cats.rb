class CreateCats < ActiveRecord::Migration
  def change
    create_table :cats do |t|
      t.date :birth_date
      t.string :color
      t.string :name, null: false
      t.string :sex, null: false
      t.text :description

      t.timestamps
    end
  end
end
