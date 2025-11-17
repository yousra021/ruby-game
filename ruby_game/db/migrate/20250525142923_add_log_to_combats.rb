class AddLogToCombats < ActiveRecord::Migration[7.0]
  def change
    add_column :combats, :log, :text
  end
end
