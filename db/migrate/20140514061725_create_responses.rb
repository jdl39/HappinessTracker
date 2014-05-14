class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.references :comment, index: true
      t.references :author, references: :users
      t.integer :votes
      t.text :content

      t.timestamps
    end
  end
end
