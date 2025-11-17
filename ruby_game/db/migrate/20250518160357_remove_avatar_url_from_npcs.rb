class RemoveAvatarUrlFromNpcs < ActiveRecord::Migration[7.0]
  def change
    remove_column :npcs, :avatar_url, :string
  end
end
