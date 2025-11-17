class DashboardController < ApplicationController
  before_action :require_login
  before_action :set_character
  before_action :require_character

  def home
    begin
      @character = current_character
      @character.gain_experience(0)
      @active_quest_progress = @character.character_quest_progresses.find_by(quest_status: "in_progress")
      @current_step = @active_quest_progress&.current_step_object
    rescue => e
      $stderr.puts "Erreur dans home : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur de chargement du personnage." and return
    end
  end

  def index
    begin
      @character = Character.includes(:weapon, :top, :bottom, :accessory).find_by(id: session[:character_id])
      @character.gain_experience(0) if @character
    rescue => e
      $stderr.puts "Erreur dans index : #{e.message}"
      @character = nil
    end

    redirect_to select_character_path, alert: "Sélectionne un personnage pour continuer." unless @character
  end

  def quests
    begin
      @available_quests = Quest.where(active: true)
      @progresses = @character.character_quest_progresses.index_by(&:quest_id)
    rescue => e
      $stderr.puts "Erreur dans quests : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur de chargement des quêtes." and return
    end
  end

  def steps
    return redirect_to dashboard_path, alert: "Sélectionne un personnage." unless @character

    begin
      if params[:quest_id]
        @quest = Quest.find_by(id: params[:quest_id])
        return redirect_to dashboard_quests_path, alert: "Quête introuvable." unless @quest

        @quest_progress = @character.character_quest_progresses.find_or_create_by!(
          quest: @quest,
          quest_status: "in_progress"
        ) do |progress|
          progress.current_step = 0
          progress.step_order = @quest.quest_steps.pluck(:id).shuffle
        end
      else
        @quest_progress = @character.character_quest_progresses.find_by(quest_status: "in_progress")
        return redirect_to dashboard_quests_path, alert: "Aucune quête en cours." unless @quest_progress

        @quest = @quest_progress.quest
      end

      ordered_ids = @quest_progress.step_order || @quest.quest_steps.order(:id).pluck(:id)
      @steps = @quest.quest_steps.where(id: ordered_ids).sort_by { |s| ordered_ids.index(s.id) }

      @current_index = (params[:step] || @quest_progress.current_step).to_i.clamp(0, @steps.size - 1)

      if @current_index > 0
        incomplete_index = (0...@current_index).find { |i| !@quest_progress.step_completed?(@steps[i]) }
        
        if incomplete_index && params[:redirected].blank?
          return redirect_to dashboard_steps_path(step: @quest_progress.current_step, redirected: true),
            alert: "⚠️ Tu dois terminer l'étape #{incomplete_index + 1} avant de continuer."
        end
      end
      
      @current_step = @steps[@current_index]
      @step_attempts = StepAttempt.where(character: @character, quest_step: @current_step)
      @step_completed = @quest_progress.step_completed?(@current_step)
      @step_success = @quest_progress.step_success?(@current_step)
    rescue => e
      $stderr.puts "Erreur dans steps : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur lors du chargement des étapes." and return
    end
  end

  def complete_step
    return redirect_to dashboard_steps_path, alert: "Personnage non trouvé." unless @character

    begin
      step = QuestStep.find_by(id: params[:id])
      return redirect_to dashboard_steps_path, alert: "Étape introuvable." unless step

      progress = @character.character_quest_progresses.find_by(quest: step.quest, quest_status: "in_progress")
      return redirect_to dashboard_steps_path, alert: "Aucune progression en cours pour cette quête." unless progress

      if progress.step_completed?(step)
        return redirect_to dashboard_steps_path(step: params[:step]), alert: "Cette étape est déjà terminée."
      end

      StepCompletionService.new(
        character: @character,
        quest_step: step,
        success: true,
        choice: "manual"
      ).call

      redirect_to dashboard_steps_path(quest_id: step.quest.id, step: params[:step].to_i + 1), notice: "Étape validée."
    rescue QuestFinished => e
      redirect_to quest_result_path(e.progress)
    rescue => e
      $stderr.puts "Erreur dans complete_step : #{e.message}"
      redirect_to dashboard_steps_path, alert: "Erreur lors de la validation de l’étape."
    end
  end

  def start_quest
    begin
      quest = Quest.find(params[:id])
      character = current_character

      progress = character.character_quest_progresses.find_or_initialize_by(quest: quest)

      if progress.persisted?
        case progress.quest_status
        when "completed"
          redirect_to dashboard_quests_path, alert: "Tu as déjà terminé cette quête."
        when "in_progress"
          redirect_to dashboard_steps_path(quest_id: quest.id)
        else
          progress.update!(
            quest_status: "in_progress",
            current_step: 0,
            step_order: quest.quest_steps.pluck(:id).shuffle
          )
          redirect_to dashboard_steps_path(quest_id: quest.id)
        end
      else
        progress.assign_attributes(
          quest_status: "in_progress",
          current_step: 0,
          step_order: quest.quest_steps.pluck(:id).shuffle
        )
        progress.save!
        redirect_to dashboard_steps_path(quest_id: quest.id)
      end
          rescue => e
      $stderr.puts "Erreur dans start_quest : #{e.message}"
      redirect_to dashboard_quests_path, alert: "Impossible de démarrer la quête."
    end
  end  

  def quest_log
    begin
      @in_progress = @character.character_quest_progresses.includes(:quest).where(quest_status: "in_progress")
      @completed   = @character.character_quest_progresses.includes(:quest).where(quest_status: "completed")
      @failed      = @character.character_quest_progresses.includes(:quest).where(quest_status: "failed")
    rescue => e
      $stderr.puts "Erreur dans quest_log : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur de chargement du journal des quêtes."
    end
  end

  private

  def set_character
    begin
      @character = Character.find_by(id: session[:character_id])
    rescue => e
      $stderr.puts "Erreur dans set_character : #{e.message}"
      @character = nil
    end
  end
end
