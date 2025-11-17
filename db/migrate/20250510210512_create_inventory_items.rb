class CreateInventoryItems < ActiveRecord::Migration[7.0]
  def change
    create_table :inventory_items do |t|
      t.references :character, foreign_key: true
      t.references :equipment, foreign_key: true
      t.boolean :equipped, default: false

      t.timestamps
    end
  end
end
