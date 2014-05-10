class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.boolean :accepted, :default => false
	  t.datetime :end_time
      t.timestamps
    end
  end
end
