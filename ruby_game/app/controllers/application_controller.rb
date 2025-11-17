class ApplicationController < ActionController::Base
  before_action :require_login
  helper_method :current_user, :current_character

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  rescue => e
    $stderr.puts "Erreur lors de la récupération de l'utilisateur courant : #{e.message}"
    nil
  end

  def current_character
    @current_character ||= Character.find_by(id: session[:character_id])
  rescue => e
    $stderr.puts "Erreur lors de la récupération du personnage courant : #{e.message}"
    nil
  end

  def require_login
    unless current_user
      redirect_to login_path, alert: "Veuillez vous connecter d'abord."
    end
  end

  def require_character
    unless current_character
      redirect_to select_characters_path, alert: "Veuillez sélectionner un personnage."
    end
  end
end
