class AddStepOrderToCharacterQuestProgresses < ActiveRecord::Migration[7.0]
  def change
    add_column :character_quest_progresses, :step_order, :json
  end
end
