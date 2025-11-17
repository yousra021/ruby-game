class Quest < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :quest_steps, dependent: :destroy
  has_many :character_quest_progresses
  validates :title, uniqueness: true

  accepts_nested_attributes_for :quest_steps, allow_destroy: true  
end
