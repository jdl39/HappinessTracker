class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :activity_type, index: true
      t.references :author, references: :users
      t.integer :votes
      t.text :content
      t.string :signature

      t.timestamps
    end
  end
end
