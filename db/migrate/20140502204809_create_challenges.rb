class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.references :sender, references: :users, index: true
	  t.references :receiver, references: :users, index: true
	  t.text :content
      t.integer :status, :default => 1
	  t.datetime :end_time
      t.timestamps
    end
  end
end
