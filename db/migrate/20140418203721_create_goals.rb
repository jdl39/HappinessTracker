class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.references :goal_type, index: true
      t.references :activity, index: true
      t.integer :num_times_completed

      t.timestamps
    end
  end
end
