class CreateGoalTypes < ActiveRecord::Migration
  def change
    create_table :goal_types do |t|
      t.references :guide, index: true
      t.references :activity_type, index: true
      t.references :measurement_type, index: true
      t.boolean :is_repeated
      t.boolean :requires_greater
      t.float :measurement_value
      t.integer :days_to_complete

      t.timestamps
    end
  end
end
