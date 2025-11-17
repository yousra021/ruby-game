class CreateNpcs < ActiveRecord::Migration[7.0]
  def change
    create_table :npcs do |t|
      t.string :name
      t.integer :health
      t.integer :strength
      t.string :avatar_url
      t.references :quest_step, null: false, foreign_key: true

      t.timestamps
    end
  end
end
