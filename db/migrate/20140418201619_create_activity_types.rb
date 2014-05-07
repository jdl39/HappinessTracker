class CreateActivityTypes < ActiveRecord::Migration
  def change
    create_table :activity_types do |t|
      t.string :name
      t.integer :num_users

      t.timestamps
    end
    add_index :activity_types, :name, unique: true
  end
end
