class CreateGoalCompletions < ActiveRecord::Migration
  def change
    create_table :goal_completions do |t|
      t.references :goal, index: true

      t.timestamps
    end
  end
end
