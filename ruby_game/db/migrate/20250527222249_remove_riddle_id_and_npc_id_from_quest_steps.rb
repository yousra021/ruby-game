class RemoveRiddleIdAndNpcIdFromQuestSteps < ActiveRecord::Migration[7.0]
  def up
    remove_column :quest_steps, :riddle_id
    remove_column :quest_steps, :npc_id
  end
  
  def down
    add_reference :quest_steps, :riddle, foreign_key: true
    add_reference :quest_steps, :npc, foreign_key: true
  end
end  
