class CreateCharacterQuestProgresses < ActiveRecord::Migration[7.0]
  def change
    create_table :character_quest_progresses do |t|
      t.references :character, null: false, foreign_key: true
      t.references :quest, null: false, foreign_key: true
      t.integer :current_step
      t.boolean :completed

      t.timestamps
    end
  end
end
