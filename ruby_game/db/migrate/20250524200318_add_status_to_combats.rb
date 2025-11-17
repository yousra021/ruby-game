class AddStatusToCombats < ActiveRecord::Migration[7.0]
  def change
    add_column :combats, :status, :string
  end
end
