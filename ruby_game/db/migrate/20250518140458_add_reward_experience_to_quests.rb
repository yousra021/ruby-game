class AddRewardExperienceToQuests < ActiveRecord::Migration[7.0]
  def change
    add_column :quests, :reward_experience, :integer
  end
end
