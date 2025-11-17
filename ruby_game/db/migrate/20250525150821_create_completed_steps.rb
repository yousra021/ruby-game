class CreateCompletedSteps < ActiveRecord::Migration[7.0]
  def change
    create_table :completed_steps do |t|
      t.references :character, null: false, foreign_key: true
      t.references :quest_step, null: false, foreign_key: true
      t.timestamps
    end

    add_index :completed_steps, [:character_id, :quest_step_id], unique: true
  end
end
