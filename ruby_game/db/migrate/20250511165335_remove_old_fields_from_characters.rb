class RemoveOldFieldsFromCharacters < ActiveRecord::Migration[7.0]
  def change
    remove_column :characters, :force, :integer
    remove_column :characters, :pv, :integer
    remove_column :characters, :top, :string
    remove_column :characters, :bottom, :string
    remove_column :characters, :accessories, :string
  end
end
