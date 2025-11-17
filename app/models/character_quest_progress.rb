class CharacterQuestProgress < ApplicationRecord
  belongs_to :character
  belongs_to :quest

  enum quest_status: {
    not_started: 0,
    in_progress: 1,
    completed: 2,
    failed: 3
  }, _prefix: true

  validates :quest_status, presence: true 

  serialize :step_order, Array

  # Passe à l'étape suivante ou termine la quête
  def advance_step!
    if current_step + 1 < step_order.count
      update!(current_step: current_step + 1)
    else
      final_status = quest_failed? ? "failed" : "completed"
      update!(quest_status: final_status)
    end
  end  

  def status
    case quest_status
    when "not_started" then "Pas commencée"
    when "in_progress" then "En cours"
    when "completed" then "Terminée"
    when "failed" then "Échouée"
    else "Inactif"
    end
  end  

  def avatar_url
    if avatar.respond_to?(:attached?) && avatar.attached?
      Rails.application.routes.url_helpers.url_for(avatar)
    elsif avatar.is_a?(String)
      "/assets/images/avatars/#{avatar}"
    else
      nil
    end
  end
  

  def last_action
    step = current_step_object
    return "Aucune étape" if step.nil?
  
    # Dernière tentative (combat ou énigme)
    last_attempt = StepAttempt.where(character: character, quest_step: step).order(created_at: :desc).first
  
    return "Aucune tentative" if last_attempt.nil?
  
    # Identifier le type de l'étape
    action_type = if step.has_combat?
                    "Combat"
                  elsif step.has_riddle?
                    "Énigme"
                  else
                    "Étape"
                  end
  
    outcome = case last_attempt.result
              when "success" then "réussi"
              when "fail" then "échoué"
              else "en cours"
              end
  
    "#{action_type} #{outcome}"
  end  

  # Étape actuelle (objet QuestStep)
  def current_step_object
    return nil if step_order.blank? || current_step.nil?
    quest.quest_steps.find_by(id: step_order[current_step])
  end

  # Est-ce que cette étape est considérée comme terminée ?
  def step_completed?(step)
    attempts = StepAttempt.where(character: character, quest_step: step)
    return false if attempts.count < 2 && !attempts.exists?(result: "success")
    true
  end

  # Est-ce que cette étape a été réussie (au moins une tentative correcte) ?
  def step_success?(step)
    StepAttempt.where(character: character, quest_step: step, result: "success").exists?
  end

  # La quête est échouée uniquement si TOUTES les étapes ont échoué
  def quest_failed?
    quest.quest_steps.all? do |step|
      attempts = StepAttempt.where(character: character, quest_step: step)
      attempts.count >= 2 && !attempts.exists?(result: "success")
    end
  end
end
