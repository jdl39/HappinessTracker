class CreateActivityTypes < ActiveRecord::Migration
  def change
    create_table :activity_types do |t|
      t.string :name
      t.integer :num_users
      t.reference :activity_word

      t.timestamps
    end
    add_index :activity_types, :name, unique: true
    add_index :activity_types, :activity_word, unique: true
  end
end
