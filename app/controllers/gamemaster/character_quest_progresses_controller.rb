class Gamemaster::CharacterQuestProgressesController < ApplicationController
  before_action :require_gamemaster!

  def index
    begin
      @progresses = CharacterQuestProgress.includes(:character, :quest)
      @characters = Character.includes(:character_quest_progresses)
    rescue => e
      $stderr.puts "Erreur dans Gamemaster::CharacterQuestProgressesController#index : #{e.message}"
      redirect_to root_path, alert: "Erreur lors du chargement des progressions." and return
    end
  end

  def show
    begin
      @progress = CharacterQuestProgress.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      $stderr.puts "Erreur : progression introuvable (id=#{params[:id]}) - #{e.message}"
      redirect_to gamemaster_character_quest_progresses_path, alert: "Progression introuvable." and return
    rescue => e
      $stderr.puts "Erreur dans show (Gamemaster::CharacterQuestProgressesController) : #{e.message}"
      redirect_to gamemaster_character_quest_progresses_path, alert: "Erreur lors de l'affichage de la progression." and return
    end
  end

  private

  def require_gamemaster!
    redirect_to root_path unless current_user&.gamemaster?
  rescue => e
    $stderr.puts "Erreur dans require_gamemaster! : #{e.message}"
    redirect_to root_path, alert: "Erreur de permission."
  end
end
