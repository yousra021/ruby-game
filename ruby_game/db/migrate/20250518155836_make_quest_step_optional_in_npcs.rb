class MakeQuestStepOptionalInNpcs < ActiveRecord::Migration[6.0]
  def change
    change_column_null :npcs, :quest_step_id, true
  end
end
