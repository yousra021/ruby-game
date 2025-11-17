class Gamemaster::NpcsController < ApplicationController
  before_action :require_gamemaster!
  before_action :set_npc, only: [:edit, :update, :destroy]

  def index
    @npc = Npc.new
    @npcs = Npc.all
  rescue => e
    $stderr.puts "Erreur dans index (NpcsController) : #{e.message}"
    redirect_to root_path, alert: "Erreur lors du chargement des PNJ."
  end

  def new
    @npc = Npc.new
  rescue => e
    $stderr.puts "Erreur dans new (NpcsController) : #{e.message}"
    redirect_to gamemaster_npcs_path, alert: "Erreur lors de l'initialisation du PNJ."
  end

  def create
    @npc = Npc.new(npc_params)
    @npcs = Npc.all

    if @npc.save
      redirect_to gamemaster_npcs_path, notice: "PNJ créé"
    else
      render :index, status: :unprocessable_entity
    end
  rescue => e
    $stderr.puts "Erreur dans create (NpcsController) : #{e.message}"
    redirect_to gamemaster_npcs_path, alert: "Erreur lors de la création du PNJ."
  end

  def edit
    # @npc déjà défini via set_npc
  end

  def update
    begin
      if npc_params[:avatar].present? && @npc.avatar.attached?
        @npc.avatar.purge
      end

      if @npc.update(npc_params)
        redirect_to gamemaster_npcs_path, notice: "PNJ mis à jour"
      else
        render :edit, status: :unprocessable_entity
      end
    rescue => e
      $stderr.puts "Erreur dans update (NpcsController) : #{e.message}"
      redirect_to gamemaster_npcs_path, alert: "Erreur lors de la mise à jour du PNJ."
    end
  end

  def destroy
    @npc.destroy
    redirect_to gamemaster_npcs_path, notice: "PNJ supprimé"
  rescue => e
    $stderr.puts "Erreur dans destroy (NpcsController) : #{e.message}"
    redirect_to gamemaster_npcs_path, alert: "Erreur lors de la suppression du PNJ."
  end

  private

  def require_gamemaster!
    redirect_to root_path unless current_user&.gamemaster?
  rescue => e
    $stderr.puts "Erreur dans require_gamemaster! : #{e.message}"
    redirect_to root_path, alert: "Erreur de permission MJ."
  end

  def set_npc
    @npc = Npc.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    $stderr.puts "PNJ introuvable (id=#{params[:id]}) : #{e.message}"
    redirect_to gamemaster_npcs_path, alert: "PNJ introuvable." and return
  rescue => e
    $stderr.puts "Erreur dans set_npc : #{e.message}"
    redirect_to gamemaster_npcs_path, alert: "Erreur lors du chargement du PNJ." and return
  end

  def npc_params
    params.require(:npc).permit(:name, :avatar, :health, :strength)
  end
end
