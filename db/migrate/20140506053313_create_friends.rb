class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.references :user, index: true
	  t.references :friend, references: :users, index: true
	  t.boolean :accepted, :default => false
      t.timestamps
    end
  end
end
