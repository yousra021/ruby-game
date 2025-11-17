class AddDefaultStatusToCharacterQuestProgress < ActiveRecord::Migration[7.0]
  def change
    change_column_default :character_quest_progresses, :quest_status, from: nil, to: 0
  end
end
