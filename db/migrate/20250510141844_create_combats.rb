class CreateCombats < ActiveRecord::Migration[7.0]
  def change
    create_table :combats do |t|
      t.references :character, null: false, foreign_key: true
      t.references :npc, null: false, foreign_key: true
      t.boolean :won
      t.integer :character_remaining_hp
      t.integer :npc_remaining_hp
      t.datetime :ended_at

      t.timestamps
    end
  end
end
