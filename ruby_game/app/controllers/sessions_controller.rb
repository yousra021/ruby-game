class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  helper_method :current_user, :current_character
  skip_before_action :require_login, only: [:new, :create, :destroy]

  def new; end

  def create
    begin
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to dashboard_path
      else
        flash[:alert] = "Email ou mot de passe invalide"
        render :new
      end
    rescue => e
      $stderr.puts "Erreur dans SessionsController#create : #{e.message}"
      flash[:alert] = "Erreur lors de la connexion. Veuillez réessayer."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end
end
