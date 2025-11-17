class AddRiddleAndNpcToQuestSteps < ActiveRecord::Migration[7.0]
  def change
    add_reference :quest_steps, :riddle, foreign_key: true
    add_reference :quest_steps, :npc, foreign_key: true    
  end
end
