class AddStatusToCharacterQuestProgresses < ActiveRecord::Migration[7.0]
  def change
    add_column :character_quest_progresses, :status, :integer, default: 0, null: false
  end
end
