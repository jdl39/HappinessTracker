class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :user, index: true
      t.references :activity_type, index: true
      t.datetime :last_accessed

      t.timestamps
    end
  end
end
