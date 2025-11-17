class Equipment < ApplicationRecord
    has_many :inventory_items
    has_many :characters, through: :inventory_items
    has_one_attached :avatar
    has_one_attached :image 
    belongs_to :quest, optional: true
    EQUIPMENT_TYPES = %w[weapon top bottom accessory consumable]
    validates :equipment_type, inclusion: { in: EQUIPMENT_TYPES }
    scope :weapons, -> { where(equipment_type: 'weapon') }
    scope :tops, -> { where(equipment_type: 'top') }
    scope :bottoms, -> { where(equipment_type: 'bottom') }
    scope :accessories, -> { where(equipment_type: 'accessory') }
    validates :description, length: { maximum: 500 }, allow_blank: true

    def equipment_type_fr
      {
        "weapon" => "Arme",
        "top" => "Vêtement",
        "bottom" => "Pantalon",
        "accessory" => "Accessoire",
        "consumable" => "Objet consommable"
      }[equipment_type] || equipment_type.capitalize
    end
    
    def bonus_description
      desc = []
      desc << "+#{bonus_force} Force" if bonus_force.to_i > 0
      desc << "+#{bonus_pv} Vie" if bonus_pv.to_i > 0
      desc << "+#{bonus_xp} XP" if bonus_xp.to_i > 0
      desc << "+#{bonus_instinct} Instinct" if bonus_instinct.to_i > 0
      desc.join(' / ')
    end    
end
