class InventoryItem < ApplicationRecord
  belongs_to :character
  belongs_to :equipment

  def self.create_random_for(character)
    random_equipment = Equipment.order("RANDOM()").first
    InventoryItem.create!(
      character: character,
      equipment: random_equipment
    )
  end
end
