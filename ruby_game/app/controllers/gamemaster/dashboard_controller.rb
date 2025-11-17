class Gamemaster::DashboardController < ApplicationController
  before_action :require_gamemaster!

  def index
    # Affichage simple, aucun traitement critique
  end

  def players
    begin
      @characters = Character.includes(:user, character_quest_progresses: [:quest, :quest_step])
    rescue => e
      $stderr.puts "Erreur dans Gamemaster::DashboardController#players : #{e.message}"
      redirect_to gamemaster_dashboard_path, alert: "Erreur lors du chargement des joueurs." and return
    end
  end

  private

  def require_gamemaster!
    unless current_user&.gamemaster?
      redirect_to root_path, alert: "Accès réservé au maître du jeu"
    end
  rescue => e
    $stderr.puts "Erreur dans require_gamemaster! : #{e.message}"
    redirect_to root_path, alert: "Erreur de permission MJ."
  end
end
