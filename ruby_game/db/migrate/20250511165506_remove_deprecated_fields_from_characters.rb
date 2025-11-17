class RemoveDeprecatedFieldsFromCharacters < ActiveRecord::Migration[7.0]
  def change
    remove_column :characters, :force, :integer if column_exists?(:characters, :force)
    remove_column :characters, :pv, :integer if column_exists?(:characters, :pv)
    remove_column :characters, :top, :string if column_exists?(:characters, :top)
    remove_column :characters, :bottom, :string if column_exists?(:characters, :bottom)
    remove_column :characters, :accessories, :string if column_exists?(:characters, :accessories)
  end
end
