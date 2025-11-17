class QuestStep < ApplicationRecord
  belongs_to :quest
  has_one :riddle, dependent: :destroy
  has_one :npc, dependent: :destroy

  accepts_nested_attributes_for :riddle, allow_destroy: true
  accepts_nested_attributes_for :npc, allow_destroy: true

  has_many :combats
  has_many :completed_steps

  # Par défaut, 30 XP si non défini
  after_initialize do
    self.base_experience ||= 30
  end

  # BONUS : corriger les anciens enregistrements au chargement (à activer si tu veux)
  after_find :fix_inconsistent_flags

  # UTILITAIRES

  def xp_reward
    base_experience || 500
  end

  # On garde les booléens comme attributs "déclaratifs" (manuels)
  def riddle_available?
    has_riddle && riddle.present?
  end

  def combat_available?
    has_combat && npc.present?
  end

  # POUR LA VUE (afficher un avertissement si incohérence)
  def incomplete_setup?
    (has_riddle && riddle.nil?) || (has_combat && npc.nil?)
  end


  validate :ensure_associated_records_exist

  private

  def ensure_associated_records_exist
    if has_riddle && riddle.nil?
      errors.add(:riddle, "L'étape est marquée avec une énigme mais aucune n'est liée.")
    end

    if has_combat && npc.nil?
      errors.add(:npc, "L'étape est marquée avec un combat mais aucun PNJ n'est lié.")
    end
  end

  # BONUS : corriger les flags si les données ne suivent pas (optionnel)
  def fix_inconsistent_flags
    self.has_riddle = false if riddle.nil? && has_riddle
    self.has_combat = false if npc.nil? && has_combat
  end
end
