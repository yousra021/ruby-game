class FixNullQuestStatus < ActiveRecord::Migration[6.1]
  def change
    change_column_default :character_quest_progresses, :quest_status, from: nil, to: 0
    change_column_null :character_quest_progresses, :quest_status, false
  end
end
