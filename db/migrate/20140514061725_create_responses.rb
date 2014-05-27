class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.references :comment, index: true
      t.references :author, references: :users
      t.integer :votes
      t.text :content
      t.string :signature

      t.timestamps
    end

    create_table :response_readers do |t|
      t.references :user
      t.references :response
    end

    create_table :response_up_voters do |t|
      t.references :user
      t.references :response
    end

    create_table :response_down_voters do |t|
      t.references :user
      t.references :response
    end
  end
end
