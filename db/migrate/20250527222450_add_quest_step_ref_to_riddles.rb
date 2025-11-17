class AddQuestStepRefToRiddles < ActiveRecord::Migration[7.0]
  def change
    # Vérifie si la colonne existe avant d'ajouter
    unless column_exists?(:riddles, :quest_step_id)
      add_reference :riddles, :quest_step, null: false, foreign_key: true
    end
  end
end
