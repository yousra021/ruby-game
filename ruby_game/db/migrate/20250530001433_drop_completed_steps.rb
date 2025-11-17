class DropCompletedSteps < ActiveRecord::Migration[7.0]
  def change
    drop_table :completed_steps, if_exists: true
  end
end
