class AddEquipmentTypeToEquipment < ActiveRecord::Migration[7.0]
  def change
    add_column :equipment, :equipment_type, :string unless column_exists?(:equipment, :equipment_type)
  end
end
