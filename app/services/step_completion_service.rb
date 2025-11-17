class StepCompletionService
  def initialize(character:, quest_step:, success:, choice:)
    @character = character
    @quest_step = quest_step
    @success = success
    @choice = choice
  end

  def call
    return unless valid_step?

    log_attempt unless max_attempts_reached?
    grant_experience
    update_progress_if_resolved
  end

  private

  def valid_step?
    @character.present? && @quest_step.present? && @quest_step.quest.present?
  end

  def max_attempts_reached?
    StepAttempt.where(character: @character, quest_step: @quest_step).count >= 2
  end

  def log_attempt
    current_count = StepAttempt.where(character: @character, quest_step: @quest_step).count
    StepAttempt.create!(
      character: @character,
      quest_step: @quest_step,
      attempt_count: current_count + 1,
      result: @success ? 'success' : 'fail',
      choice: @choice
    )
  end

  def grant_experience
    base_xp = @success ? (@quest_step.base_experience || 50) : 10
  
    # Calcul des bonus via équipements
    bonus_xp = [@character.weapon, @character.top, @character.bottom, @character.accessory]
                .compact.sum { |e| e.bonus_xp.to_i }
  
    total_xp = base_xp + bonus_xp
  
    @character.gain_experience(total_xp)
  end
  
  
  def update_progress_if_resolved
    progress = @character.character_quest_progresses.find_by(
      quest: @quest_step.quest,
      quest_status: :in_progress
    )
    return unless progress
    return unless progress.step_completed?(@quest_step)
  
    if progress.current_step + 1 < progress.step_order.size
      progress.increment!(:current_step)
    else
      status = progress.quest_failed? ? :failed : :completed
      progress.update!(quest_status: status)
  
      # ✅ Ajoute un bonus d'XP à la fin d'une quête réussie :
      if status == :completed
        @character.gain_experience(200) 
      end
  
      raise QuestFinished.new(progress)
    end    
  end
  end
