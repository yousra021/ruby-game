class AddQuestStepToCombats < ActiveRecord::Migration[7.0]
  def change
    add_reference :combats, :quest_step, foreign_key: true 
  end
end
