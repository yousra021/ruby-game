class Gamemaster::EquipmentsController < ApplicationController
  before_action :require_gamemaster!
  before_action :set_equipment, only: [:edit, :update, :destroy]

  def index
    @equipment = Equipment.new
    @equipments = Equipment.all
  rescue => e
    $stderr.puts "Erreur dans index (EquipmentsController) : #{e.message}"
    redirect_to root_path, alert: "Erreur lors du chargement des équipements."
  end

  def create
    @equipment = Equipment.new(equipment_params)
    @equipments = Equipment.all

    if @equipment.save
      redirect_to gamemaster_equipments_path, notice: "Équipement créé"
    else
      render :index, status: :unprocessable_entity
    end
  rescue => e
    $stderr.puts "Erreur dans create (EquipmentsController) : #{e.message}"
    redirect_to gamemaster_equipments_path, alert: "Erreur lors de la création de l'équipement."
  end

  def edit
    # @equipment déjà défini dans set_equipment
  end

  def update
    if @equipment.update(equipment_params)
      redirect_to gamemaster_equipments_path, notice: "Équipement mis à jour"
    else
      render :edit, status: :unprocessable_entity
    end
  rescue => e
    $stderr.puts "Erreur dans update (EquipmentsController) : #{e.message}"
    redirect_to gamemaster_equipments_path, alert: "Erreur lors de la mise à jour de l'équipement."
  end

  def destroy
    @equipment.destroy
    redirect_to gamemaster_equipments_path, notice: "Équipement supprimé"
  rescue => e
    $stderr.puts "Erreur dans destroy (EquipmentsController) : #{e.message}"
    redirect_to gamemaster_equipments_path, alert: "Erreur lors de la suppression de l'équipement."
  end

  private

  def require_gamemaster!
    redirect_to root_path unless current_user&.gamemaster?
  rescue => e
    $stderr.puts "Erreur dans require_gamemaster! : #{e.message}"
    redirect_to root_path, alert: "Erreur de permission."
  end

  def set_equipment
    @equipment = Equipment.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    $stderr.puts "Équipement introuvable (id=#{params[:id]}) : #{e.message}"
    redirect_to gamemaster_equipments_path, alert: "Équipement introuvable." and return
  rescue => e
    $stderr.puts "Erreur dans set_equipment : #{e.message}"
    redirect_to gamemaster_equipments_path, alert: "Erreur lors du chargement de l’équipement." and return
  end

  def equipment_params
    params.require(:equipment).permit(
      :name, :equipment_type, :bonus_force, :bonus_pv, :bonus_xp,
      :bonus_instinct
    )
  end
end
    