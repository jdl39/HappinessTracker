class AddIsHappyToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_happy, :boolean, :default => true	  
  end
end
