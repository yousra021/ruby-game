class CreateQuests < ActiveRecord::Migration[7.0]
  def change
    create_table :quests do |t|
      t.string :title
      t.text :description
      t.boolean :active
      t.references :creator, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
