class AddTurnToCombats < ActiveRecord::Migration[7.0]
  def change
    add_column :combats, :turn, :string
  end
end
