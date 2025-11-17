class InventoryItemsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_character, except: [:equip_direct]
  before_action :set_inventory_item, only: [:equip, :unequip, :show]

  def create
    begin
      character = Character.find(params[:character_id])
      equipment = Equipment.find(params[:item_id])

      InventoryItem.create!(character: character, equipment: equipment)

      redirect_to dashboard_path, notice: "#{equipment.name} ajouté à l'inventaire."
    rescue => e
      $stderr.puts "Erreur dans create : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur lors de l'ajout de l'objet."
    end
  end

  def index
    begin
      @inventory_items = @character.inventory_items.includes(:equipment)
      respond_to do |format|
        format.html
        format.json {
          render json: @inventory_items.as_json(include: {
            equipment: {
              only: [:name, :equipment_type, :bonus_force, :bonus_pv, :bonus_xp, :bonus_instinct, :image]
            }
          })
        }
      end
    rescue => e
      $stderr.puts "Erreur dans index : #{e.message}"
      render_error("Impossible de charger l'inventaire.")
    end
  end

  def equip
    begin
      @character.equip(@inventory_item.equipment)
      redirect_to character_inventory_item_path(@character, @inventory_item), notice: "Objet équipé avec succès."
    rescue => e
      $stderr.puts "Erreur dans equip : #{e.message}"
      redirect_to character_inventory_item_path(@character, @inventory_item), alert: e.message
    end
  end

  def unequip
    if @inventory_item.equipped
      begin
        @character.unequip(@inventory_item.equipment)
        redirect_to character_inventory_item_path(@character, @inventory_item), notice: "Objet déséquipé."
      rescue => e
        $stderr.puts "Erreur dans unequip : #{e.message}"
        redirect_to character_inventory_item_path(@character, @inventory_item), alert: e.message
      end
    else
      redirect_to character_inventory_item_path(@character, @inventory_item), alert: "Cet objet n'est pas équipé."
    end
  end

  def show
    begin
      @equipment = @inventory_item.equipment
    rescue => e
      $stderr.puts "Erreur dans show : #{e.message}"
      redirect_to character_inventory_items_path(@character), alert: "Erreur lors de l'affichage de l'objet."
    end
  end

  def equip_direct
    begin
      character = current_character
      unless character
        redirect_to select_character_path, alert: "Veuillez sélectionner un personnage actif." and return
      end

      item = Equipment.find(params[:id])

      unless character.inventory_items.exists?(equipment_id: item.id)
        InventoryItem.create!(character: character, equipment: item)
      end

      character.equip(item) if character.respond_to?(:equip)

      redirect_to character_inventory_items_path(current_character), notice: "#{item.name} a été équipé."
    rescue => e
      $stderr.puts "Erreur dans equip_direct : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur lors de l’équipement direct."
    end
  end

  private

  def set_character
    @character = Character.find(params[:character_id])
  rescue ActiveRecord::RecordNotFound => e
    render_error("Personnage introuvable")
    $stderr.puts "Erreur dans set_character : #{e.message}"
  end

  def set_inventory_item
    @inventory_item = @character.inventory_items.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render_error("Objet introuvable dans l’inventaire")
    $stderr.puts "Erreur dans set_inventory_item : #{e.message}"
  end

  def render_error(message)
    STDERR.puts message
    respond_to do |format|
      format.html { redirect_to dashboard_path, alert: message }
      format.json { render json: { error: message }, status: :unprocessable_entity }
    end
  end
end
