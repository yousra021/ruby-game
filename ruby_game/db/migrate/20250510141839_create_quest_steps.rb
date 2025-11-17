class CreateQuestSteps < ActiveRecord::Migration[7.0]
  def change
    create_table :quest_steps do |t|
      t.references :quest, null: false, foreign_key: true
      t.text :description
      t.boolean :has_riddle
      t.boolean :has_combat
      t.integer :step_order

      t.timestamps
    end
  end
end
