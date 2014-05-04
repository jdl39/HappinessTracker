class AddRefsToFriendShip < ActiveRecord::Migration
  def change
	  add_reference :friendships, :first, references: :users, index: true
	  add_reference :friendships, :second, references: :users, index: true
  end
end
