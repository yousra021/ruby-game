class AddQuestStepRefToNpcs < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:npcs, :quest_step_id)
      add_reference :npcs, :quest_step, null: false, foreign_key: true
    end
  end
end
