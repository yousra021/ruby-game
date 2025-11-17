class RenameStatusToQuestStatusInCharacterQuestProgresses < ActiveRecord::Migration[7.0]
  def change
    rename_column :character_quest_progresses, :status, :quest_status
  end
end
