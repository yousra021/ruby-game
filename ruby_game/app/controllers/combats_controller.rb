class CombatsController < ApplicationController
  before_action :require_login
  before_action :set_combat


  def randomized_damage(base)
    variance = (base * 0.3).round
    rand(base - variance..base + variance)
  end
  
  def critical_hit?(chance = 10)
    rand(100) < chance
  end
  
  def show
    begin
      @character = @combat.character
      char = @combat.character
      @npc = @combat.npc
      @step = @combat.quest_step
      
      if @combat.status == 'won'
        @base_xp = @combat.xp_reward || 30
        @bonus_xp = @character.total_equipment_bonus_xp
        @total_xp = @base_xp + @bonus_xp
      end
      
      # ✅ N'attaque QUE si le paramètre est bien présent
      if @combat.turn == 'npc' && params[:npc_attack].present?
        @combat.character_remaining_hp ||= @character.total_health
        dmg = randomized_damage(@npc.strength)
        @combat.character_remaining_hp -= dmg
        @combat.append_log("☠️ Le PNJ t’a infligé #{dmg} dégâts.")
        @combat.save!
  
        session[:zombie_attacked] = true
  
        if @combat.character_remaining_hp <= 0
          @combat.update(status: 'lost', character_remaining_hp: 0)
          redirect_to failure_combat_path(@combat) and return
        else
          @combat.update(turn: 'player')
          redirect_to combat_path(@combat) and return
        end
      end
  
    rescue => e
      $stderr.puts "Erreur dans show combat : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur pendant le combat."
    end
  end
    
  def flee
    begin
      instinct = current_character.total_instinct.to_i
      chance = rand(100)

      if chance < (instinct * 2)
        @combat.update(status: 'fled')
        @combat.append_log("🏃 Tu as fui avec succès.")
        redirect_to dashboard_steps_path, notice: "Fuite réussie."
      else
        @combat.update(turn: 'npc')
        @combat.append_log("🚪 Tu as tenté de fuir… échec !")
        redirect_to combat_path(@combat), alert: "Échec de la fuite ! Le PNJ attaque."
      end
    rescue => e
      $stderr.puts "Erreur dans flee : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur pendant la tentative de fuite."
    end
  end

  def attack
    begin
      char = @combat.character
      npc = @combat.npc
  
      if @combat.turn == 'player'
        dmg_player = randomized_damage(char.total_strength)
        is_crit = critical_hit?
        dmg_player *= 2 if is_crit
        @combat.npc_remaining_hp -= dmg_player
        crit_log = is_crit ? "💥 Coup critique !" : ""
        @combat.append_log("🗡️ Tu as infligé #{dmg_player} dégâts. #{crit_log}")
        @combat.turn = 'npc'
      end
  
      @combat.save!
  
      if @combat.npc_remaining_hp <= 0
        @combat.update(status: 'won')
        redirect_to success_combat_path(@combat) and return
      elsif @combat.character_remaining_hp <= 0
        @combat.update(status: 'lost', character_remaining_hp: 0)
        redirect_to failure_combat_path(@combat) and return
      else
        redirect_to combat_path(@combat)
      end
  
    rescue => e
      $stderr.puts "Erreur dans attack : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur pendant le combat."
    end
  end

  def failure
    begin
      StepCompletionService.new(
        character: current_character,
        quest_step: @combat.quest_step,
        success: false,
        choice: "combat"
      ).call

      redirect_to step_result_path(step_id: @combat.quest_step.id, success: false)
    rescue QuestFinished => e
      redirect_to quest_result_path(e.progress.id)
    rescue => e
      $stderr.puts "Erreur dans failure : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur pendant l’échec du combat."
    end
  end

  def success
    @combat = Combat.find(params[:id])
    @rewards = Equipment.order("RANDOM()").limit(3)
  
    if @combat.status == 'won' && @combat.ended_at.nil?
      base_xp = @combat.xp_reward || 30
      bonus_xp = current_character.total_equipment_bonus_xp
      total_xp = base_xp + bonus_xp
  
      current_character.gain_experience(total_xp)
      @combat.update(ended_at: Time.current)
  
      # ✅ Enregistre la tentative réussie
      StepAttempt.create!(
        character: current_character,
        quest_step: @combat.quest_step,
        result: "success",
        attempt_count: 1
      )
  
      # Avancer l'étape
      progress = CharacterQuestProgress.find_by(character: current_character, quest: @combat.quest_step.quest)
      progress&.advance_step!
  
      # Donner un medikit
      medikit = Equipment.find_by(name: "Medikit")
      InventoryItem.create!(character: current_character, equipment: medikit, equipped: false) if medikit
  
      # 🔄 Redirection selon progression
      if progress&.quest_status == "completed"
        redirect_to quest_result_path(progress.id) and return
      else
        redirect_to dashboard_steps_path(quest_id: progress.quest.id, step: progress.current_step) and return
      end
    end
  
    # Pour l'affichage de la page success si la quête était déjà finie
    @base_xp = @combat.xp_reward || 30
    @bonus_xp = current_character.total_equipment_bonus_xp
    @total_xp = @base_xp + @bonus_xp
  end
      

  def use_item
    item = current_character.inventory_items
                            .joins(:equipment)
                            .where(equipped: false, equipment: { equipment_type: "consumable" })
                            .order("equipment.bonus_pv DESC")
                            .first
  
    if item && item.equipment.bonus_pv.to_i > 0
      heal = item.equipment.bonus_pv.to_i
      @combat.character_remaining_hp ||= current_character.total_health
      @combat.character_remaining_hp += heal
      @combat.character_remaining_hp = [@combat.character_remaining_hp, current_character.total_health].min
      @combat.append_log("🧪 Tu utilises #{item.equipment.name} et récupères #{heal} PV.")
      @combat.save!
  
      item.destroy # supprime l’objet de l’inventaire après usage
      redirect_to combat_path(@combat), notice: "Objet utilisé."
    else
      redirect_to combat_path(@combat), alert: "Aucun objet de soin disponible."
    end
  end
  

  private

  def set_combat
    begin
      @combat = Combat.find(params[:id])
    rescue => e
      $stderr.puts "Erreur lors du chargement du combat (id=#{params[:id]}) : #{e.message}"
      redirect_to dashboard_path, alert: "Combat introuvable."
    end
  end
end
