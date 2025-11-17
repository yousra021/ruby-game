class User < ApplicationRecord
  has_secure_password

  has_many :characters
  belongs_to :active_character, class_name: 'Character', optional: true

  has_many :quests, foreign_key: :creator_id
  
  def gamemaster?
    is_gamemaster
  end
end
