class CreateStepAttempts < ActiveRecord::Migration[7.0]
  def change
    create_table :step_attempts do |t|
      t.references :character, null: false, foreign_key: true
      t.references :quest_step, null: false, foreign_key: true
      t.integer :attempt_count
      t.string :result
      t.string :choice

      t.timestamps
    end
  end
end
