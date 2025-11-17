class AddDefaultStatsToCharacters < ActiveRecord::Migration[6.1]
  def change
    change_column_default :characters, :strength, from: nil, to: 10
    change_column_default :characters, :health, from: nil, to: 10
    change_column_default :characters, :instinct, from: nil, to: 10
  end
end
