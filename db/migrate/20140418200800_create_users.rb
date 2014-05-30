class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :password_digest
      t.integer :phone
      t.string :username
      t.string :remember_token
      t.string :country
      t.string :city
      t.integer :readable_comments_count
      t.integer :readable_responses_count
      t.boolean :is_happy, default:true

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :phone, unique: true
    add_index :users, :username, unique: true
    add_index :users, :remember_token, unique: true
  end
end
