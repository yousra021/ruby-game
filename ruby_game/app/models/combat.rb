class Combat < ApplicationRecord
  belongs_to :character
  belongs_to :npc
  belongs_to :quest_step

  def xp_reward
    quest_step&.base_experience || 30
  end  

  def append_log(entry)
    self.log ||= ""
    self.log += "#{entry}\n"
    save!
  end
end
