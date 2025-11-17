class AddDetailsToCharacters < ActiveRecord::Migration[7.0]
  def change
    add_column :characters, :force, :integer, default: 10
    add_column :characters, :pv, :integer, default: 10
    add_column :characters, :instinct, :integer, default: 10
    add_column :characters, :avatar, :string
    add_column :characters, :top, :string
    add_column :characters, :bottom, :string
    add_column :characters, :accessories, :string
  end
end
