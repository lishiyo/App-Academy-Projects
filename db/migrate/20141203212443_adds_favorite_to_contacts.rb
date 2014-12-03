class AddsFavoriteToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :favorited, :boolean, default: false
  end
end
