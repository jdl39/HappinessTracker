class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :user, index: true
      t.references :activity_type, index: true
      t.references :measurement_type, index: true
      t.datetime :last_accessed
      t.integer :num_measured

      t.timestamps
    end
    add_index :activities, [:user_id, :activity_type_id], unique: true
  end
end
