class CreateCharacters < ActiveRecord::Migration[7.0]
  def change
    create_table :characters do |t|
      t.string :name
      t.string :role
      t.integer :level
      t.integer :experience
      t.integer :health
      t.integer :strength
      t.integer :available_points
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
