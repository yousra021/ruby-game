class AddBaseExperienceToQuestSteps < ActiveRecord::Migration[7.0]
  def change
    add_column :quest_steps, :base_experience, :integer
  end
end
