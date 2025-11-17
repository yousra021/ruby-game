class CreateRiddles < ActiveRecord::Migration[7.0]
  def change
    create_table :riddles do |t|
      t.text :question
      t.string :correct_answer
      t.text :wrong_answers
      t.references :quest_step, null: false, foreign_key: true

      t.timestamps
    end
  end
end
