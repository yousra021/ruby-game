class AddEquippedItemsToCharacters < ActiveRecord::Migration[7.0]
  def change
    add_column :characters, :weapon_id, :integer
    add_column :characters, :top_id, :integer
    add_column :characters, :bottom_id, :integer
    add_column :characters, :accessory_id, :integer
  end
end
