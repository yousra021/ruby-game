class ChangeQuestStatusToIntegerInCharacterQuestProgresses < ActiveRecord::Migration[7.0]
  def change
    # Étape 1 : Supprimer le default temporairement
    change_column_default :character_quest_progresses, :quest_status, from: 'not_started', to: nil

    # Étape 2 : Changer le type en integer
    change_column :character_quest_progresses, :quest_status, :integer, using: 'quest_status::integer'

    # Étape 3 (optionnelle mais propre) : Remettre le default si tu en veux un
    change_column_default :character_quest_progresses, :quest_status, from: nil, to: 0
  end
end
