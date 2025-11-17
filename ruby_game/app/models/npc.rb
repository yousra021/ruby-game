class Npc < ApplicationRecord
  belongs_to :quest_step, optional: true
  has_one_attached :avatar

  validates :name, :health, :strength, presence: true

  # Renvoie la vie actuelle du NPC
  def hp
    health.to_i
  end

  # Renvoie la force du NPC
  def force
    strength.to_i
  end
  
end
