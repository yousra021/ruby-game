class CreateEquipment < ActiveRecord::Migration[7.0]
  def change
    create_table :equipment do |t|
      t.string :name
      t.string :equipment_type
      t.integer :bonus_force
      t.integer :bonus_pv
      t.integer :bonus_xp
      t.integer :bonus_instinct
      t.string :image

      t.timestamps
    end
  end
end
