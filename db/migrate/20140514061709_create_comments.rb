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

    create_table :comment_readers do |t|
      t.references :user
      t.references :comment
    end

    create_table :comment_up_voters do |t|
      t.references :user
      t.references :comment
    end

    create_table :comment_down_voters do |t|
      t.references :user
      t.references :comment
    end
  end
end
