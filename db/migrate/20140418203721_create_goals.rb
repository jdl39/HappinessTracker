class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.references :goal_type, index: true
      t.references :activity, index: true
      t.references :completing_measurement

      t.datetime :start_time
      t.boolean :active

      t.timestamps
    end
  end
end
