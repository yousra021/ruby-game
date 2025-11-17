class Character < ApplicationRecord
  belongs_to :user
  has_many :inventory_items, dependent: :destroy
  has_many :equipment, through: :inventory_items
  has_many :combats, dependent: :destroy
  has_many :character_quest_progresses, dependent: :destroy
  has_many :completed_steps, dependent: :destroy
  
  # has_one_attached :avatar  # <-- Commente ou supprime cette ligne
  
  belongs_to :weapon, class_name: "Equipment", optional: true
  belongs_to :top, class_name: "Equipment", optional: true
  belongs_to :bottom, class_name: "Equipment", optional: true
  belongs_to :accessory, class_name: "Equipment", optional: true

  validates :name, presence: true, length: { minimum: 3, maximum: 20 }
  validates :strength, :health, :instinct,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }

  after_initialize :set_default_stats, if: :new_record?
  after_create :assign_default_equipment

  def assign_default_equipment
    base_weapon = Equipment.find_by(name: "knife")
    return unless base_weapon

    inventory_item = inventory_items.create!(equipment: base_weapon)

    update!(weapon: base_weapon)
  end

  def set_default_stats
    self.strength ||= 10
    self.health ||= 30 # ✅ Plus de PV de base
    self.instinct ||= 10
    self.available_points ||= 10
    self.level ||= 1
    self.experience ||= 0
  end

  # Renvoie la "vie" actuelle pour le combat, en prenant en compte les bonus d’équipement
  def hp
    total_health
  end

  # Force totale avec bonus équipement
  def total_strength
    base = strength.to_i
    bonus = [weapon, top, bottom, accessory].compact.sum { |e| e.bonus_force.to_i }
    base + bonus
  end

  def total_health
    base = health.to_i
    bonus = [weapon, top, bottom, accessory].compact.sum { |e| e.bonus_pv.to_i }
    base + bonus
  end

  def total_instinct
    base = instinct.to_i
    bonus = [weapon, top, bottom, accessory].compact.sum { |e| e.bonus_instinct.to_i }
    base + bonus
  end

  # Pour cohérence, alias total_strength sous force
  alias_method :force, :total_strength

  # Gestion de l'expérience et du niveau
  def gain_experience(amount)
    self.experience ||= 0
    self.level ||= 1
    self.available_points ||= 0

    self.experience += amount

    while self.experience >= experience_to_next_level
      level_up
    end

    save!
  end

  def experience_to_next_level
    100 * (level || 1)
  end

  def level_up
    self.experience -= experience_to_next_level
    self.level += 1
    self.available_points += 4 
  end

  # Méthodes equip et unequip (à ajouter si tu veux)
  def equip(equipment)
    equipment_type = equipment.equipment_type

    inventory_items.joins(:equipment)
                  .where(equipped: true, equipment: { equipment_type: equipment_type })
                  .update_all(equipped: false)

    case equipment_type
    when 'weapon'    then update(weapon: equipment)
    when 'top'       then update(top: equipment)
    when 'bottom'    then update(bottom: equipment)
    when 'accessory' then update(accessory: equipment)
    else
      raise "Type d'équipement inconnu : #{equipment_type}"
    end

    inventory_items.where(equipment: equipment).update_all(equipped: true)
  end

  def unequip(equipment)
    equipment_type = equipment.equipment_type

    case equipment_type
    when 'weapon'    then update(weapon: nil)
    when 'top'       then update(top: nil)
    when 'bottom'    then update(bottom: nil)
    when 'accessory' then update(accessory: nil)
    else
      raise "Type d'équipement inconnu : #{equipment_type}"
    end

    inventory_items.where(equipment: equipment).update_all(equipped: false)
  end

  def total_equipment_bonus_xp
    [weapon, top, bottom, accessory].compact.sum { |e| e.bonus_xp.to_i }
  end  
end
