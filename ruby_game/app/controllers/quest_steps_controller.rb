class QuestStepsController < ApplicationController
  before_action :require_login

  def show
    begin
      @step = QuestStep.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      $stderr.puts "Erreur : étape introuvable (id=#{params[:id]}) - #{e.message}"
      redirect_to dashboard_path, alert: "Étape de quête introuvable." and return
    rescue => e
      $stderr.puts "Erreur dans show (QuestStepsController) : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur lors de l'affichage de l'étape." and return
    end
  end

  def start_combat
    character = current_character
    return redirect_to dashboard_path, alert: "Personnage non trouvé." unless character

    begin
      step = QuestStep.find_by(id: params[:step_id])
      return redirect_to dashboard_path, alert: "Étape introuvable." unless step
      return redirect_to dashboard_path, alert: "Cette étape n’a pas de PNJ." unless step.combat_available?

      existing_combat = Combat.find_by(character: character, quest_step: step, status: 'ongoing')
      if existing_combat
        redirect_to combat_path(existing_combat), alert: "⚔️ Tu es déjà en combat pour cette étape."
      else
        combat = Combat.create!(
          character: character,
          npc: step.npc,
          quest_step: step,
          turn: 'player',
          status: 'ongoing',
          character_remaining_hp: character.total_health,
          npc_remaining_hp: step.npc.health
        )

        redirect_to combat_path(combat)
      end
    rescue ActiveRecord::RecordInvalid => e
      $stderr.puts "Erreur ActiveRecord dans start_combat : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur lors de l'initialisation du combat : #{e.message}"
    rescue => e
      $stderr.puts "Erreur générale dans start_combat : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur lors de la création du combat."
    end
  end
end
