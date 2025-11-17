class CharactersController < ApplicationController  
  before_action :require_login
  skip_before_action :verify_authenticity_token, only: [:create]

  def new
    @character = Character.new
  end

  def show
    begin
      @character = current_user.characters.find_by(id: params[:id])
    rescue => e
      $stderr.puts "Erreur lors de l'affichage du personnage : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur interne." and return
    end

    Rails.logger.debug "Session user_id: #{session[:user_id]}"

    unless @character
      redirect_to dashboard_path, alert: "Personnage introuvable." and return
    end
  end

  def create
    if current_user.nil?
      redirect_to login_path, alert: "Vous devez être connecté." and return
    end

    @character = current_user.characters.new(character_params)
    @character.available_points = 10

    if @character.save
      session[:character_id] = @character.id

      begin
        equip_starting_items
        start_first_active_quest
      rescue => e
        $stderr.puts "Erreur post-création personnage : #{e.message}"
      end

      redirect_to dashboard_index_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def start_first_active_quest
    first_quest = Quest.first
    return unless first_quest

    CharacterQuestProgress.create!(
      character: @character,
      quest: first_quest,
      current_step: 0,
      quest_status: 'in_progress',
      step_order: first_quest.quest_steps.order(:id).pluck(:id)
    )
  end

  def select
    begin
      @characters = current_user.characters
    rescue => e
      $stderr.puts "Erreur lors du chargement des personnages : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur interne." and return
    end
  end

  def select_character
    begin
      @character = current_user.characters.find_by(id: params[:id])
    rescue => e
      $stderr.puts "Erreur lors de la sélection du personnage : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur interne." and return
    end

    if @character
      session[:character_id] = @character.id
      redirect_to dashboard_index_path, notice: "Personnage sélectionné avec succès !"
    else
      redirect_to dashboard_path, alert: "Personnage introuvable ou non autorisé."
    end
  end

  def edit_stats
    begin
      @character = current_user.characters.find(params[:id])
    rescue => e
      $stderr.puts "Erreur d'accès à l'édition des stats : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur interne." and return
    end
  end

  def start_quest
    begin
      @character = current_user.characters.find(params[:id])
      quest = Quest.find(params[:quest_id])
    rescue => e
      $stderr.puts "Erreur lors du démarrage de quête : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur interne." and return
    end

    if @character && quest
      if @character.character_quest_progresses.where(quest_status: 'in_progress').exists?
        redirect_to dashboard_steps_path, alert: "Vous avez déjà une quête en cours." and return
      end

      step_ids = quest.quest_steps.order(:id).pluck(:id).shuffle

      CharacterQuestProgress.create!(
        character: @character,
        quest: quest,
        current_step: 0,
        quest_status: 'in_progress',
        step_order: step_ids
      )

      redirect_to dashboard_steps_path, notice: "Quête '#{quest.title}' commencée !"
    else
      redirect_to dashboard_path, alert: "Personnage ou quête introuvable."
    end
  end

  def update_stats
    begin
      @character = current_user.characters.find_by(id: params[:id])
    rescue => e
      $stderr.puts "Erreur lors de la mise à jour des stats : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur interne." and return
    end

    unless @character
      redirect_to dashboard_path, alert: "Accès non autorisé." and return
    end

    new_strength  = params[:character][:strength].to_i
    new_health    = params[:character][:health].to_i
    new_instinct  = params[:character][:instinct].to_i

    used_points = (new_strength - @character.strength.to_i) +
                  (new_health - @character.health.to_i) +
                  (new_instinct - @character.instinct.to_i)

    if used_points > @character.available_points.to_i
      redirect_to edit_stats_character_path(@character), alert: "Tu n’as pas assez de points disponibles." and return
    end

    @character.strength = new_strength
    @character.health   = new_health
    @character.instinct = new_instinct
    @character.available_points -= used_points
    @character.save!

    redirect_to character_path(@character), notice: "Caractéristiques mises à jour avec succès !"
  end

  private

  def equip_starting_items
    starting_weapon = Equipment.find_by(name: "Couteau", equipment_type: "weapon")
    if starting_weapon
      InventoryItem.create!(character: @character, equipment: starting_weapon, equipped: true)
      @character.update!(weapon: starting_weapon)
    end

    equip_initial_item(:top, params[:character][:top_id])
    equip_initial_item(:bottom, params[:character][:bottom_id])
    equip_initial_item(:accessory, params[:character][:accessory_id])
  end

  def equip_initial_item(type, equipment_id)
    return if equipment_id.blank?

    item = Equipment.find_by(id: equipment_id, equipment_type: type)
    return unless item

    InventoryItem.create!(character: @character, equipment: item, equipped: true)
    @character.update!("#{type}_id": item.id)
  end

  def character_params
    if action_name == "update_stats"
      params.require(:character).permit(:strength, :health, :instinct)
    else
      params.require(:character).permit(
        :name, :strength, :health, :instinct, :avatar,
        :top_id, :bottom_id, :accessory_id
      )
    end
  end

  def require_login
    redirect_to login_path unless session[:user_id]
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  rescue => e
    $stderr.puts "Erreur lors de la récupération de l'utilisateur : #{e.message}"
    nil
  end
end
