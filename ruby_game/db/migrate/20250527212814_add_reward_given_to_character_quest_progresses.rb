class AddRewardGivenToCharacterQuestProgresses < ActiveRecord::Migration[7.0]
  def change
    add_column :character_quest_progresses, :reward_given, :boolean
  end
end
