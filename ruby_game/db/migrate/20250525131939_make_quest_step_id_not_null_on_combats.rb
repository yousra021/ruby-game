class MakeQuestStepIdNotNullOnCombats < ActiveRecord::Migration[7.0]
  def change
    change_column_null :combats, :quest_step_id, false
  end
end
