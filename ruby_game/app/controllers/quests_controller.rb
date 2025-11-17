class QuestsController < ApplicationController
  before_action :require_login
  before_action :set_character

  def success
    begin
      @quest = Quest.find(params[:id])
      @rewards = Equipment.order("RANDOM()").limit(3)
    rescue ActiveRecord::RecordNotFound => e
      $stderr.puts "Erreur : quête introuvable (id=#{params[:id]}) - #{e.message}"
      redirect_to dashboard_path, alert: "Quête introuvable." and return
    rescue => e
      $stderr.puts "Erreur dans success (QuestsController) : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur lors du chargement de la réussite de la quête." and return
    end
  end

  def failed
    begin
      @quest = Quest.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      $stderr.puts "Erreur : quête introuvable (id=#{params[:id]}) - #{e.message}"
      redirect_to dashboard_path, alert: "Quête introuvable." and return
    rescue => e
      $stderr.puts "Erreur dans failed (QuestsController) : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur lors du chargement de l’échec de la quête." and return
    end
  end

  private

  def set_character
    @character = current_character
  rescue => e
    $stderr.puts "Erreur dans set_character : #{e.message}"
    @character = nil
  end
end
