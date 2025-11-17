class ChangeQuestStatusTypeInCharacterQuestProgresses < ActiveRecord::Migration[7.0]
  def up
    # On change la colonne en string
    change_column :character_quest_progresses, :quest_status, :string, using: 'quest_status::text'
  end

  def down
    # On revient en integer si besoin
    change_column :character_quest_progresses, :quest_status, :integer, using: 'quest_status::integer'
  end
end
