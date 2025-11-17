class AddActiveCharacterToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :active_character_id, :integer
  end
end
