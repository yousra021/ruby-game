class AddStepTypeToQuestSteps < ActiveRecord::Migration[7.0]
  def change
    add_column :quest_steps, :step_type, :integer
  end
end
