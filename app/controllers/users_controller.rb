class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
  rescue => e
    $stderr.puts "Erreur dans UsersController#new : #{e.message}"
    redirect_to root_path, alert: "Erreur lors de la création du formulaire utilisateur." and return
  end

  def select
    begin
      @characters = current_user.characters
    rescue => e
      $stderr.puts "Erreur dans UsersController#select : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur lors du chargement des personnages." and return
    end
  end

  def set_active
    begin
      character = current_user.characters.find(params[:id])
      current_user.update(active_character: character)
      redirect_to dashboard_path, notice: "Personnage actif mis à jour."
    rescue ActiveRecord::RecordNotFound => e
      $stderr.puts "Erreur : personnage introuvable pour l'utilisateur (id=#{params[:id]}) - #{e.message}"
      redirect_to dashboard_path, alert: "Personnage non trouvé." and return
    rescue => e
      $stderr.puts "Erreur dans UsersController#set_active : #{e.message}"
      redirect_to dashboard_path, alert: "Impossible de définir le personnage actif." and return
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Connecté !"
    else
      render :new
    end
  rescue => e
    $stderr.puts "Erreur dans UsersController#create : #{e.message}"
    flash[:alert] = "Erreur lors de la création du compte."
    render :new
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
