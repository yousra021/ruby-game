class RiddlesController < ApplicationController
  before_action :set_riddle, only: [:show, :check]

  def show
    begin
      wrongs = @riddle.wrong_answers ? JSON.parse(@riddle.wrong_answers) : []
      @answers = wrongs + [@riddle.correct_answer]
      @answers.shuffle!
    rescue JSON::ParserError => e
      $stderr.puts "Erreur JSON dans show (RiddlesController) : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur de chargement des réponses." and return
    rescue => e
      $stderr.puts "Erreur dans show (RiddlesController) : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur d'affichage de l'énigme." and return
    end
  end

  def check
    begin
      success = params[:answer] == @riddle.correct_answer

      StepCompletionService.new(
        character: current_character,
        quest_step: @riddle.quest_step,
        success: success,
        choice: "riddle"
      ).call

      redirect_to step_result_path(step_id: @riddle.quest_step.id, success: success)
    rescue QuestFinished => e
      redirect_to quest_result_path(e.progress.id)
    rescue => e
      $stderr.puts "Erreur dans check (RiddlesController) : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur lors de la validation de l’énigme."
    end
  end

  private

  def set_riddle
    begin
      @riddle = Riddle.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      $stderr.puts "Erreur : énigme introuvable (id=#{params[:id]}) - #{e.message}"
      redirect_to dashboard_path, alert: "Énigme introuvable." and return
    rescue => e
      $stderr.puts "Erreur dans set_riddle : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur lors du chargement de l’énigme." and return
    end
  end
end
