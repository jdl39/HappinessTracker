class FriendsController < ApplicationController

   # Retrieves a user's accepted friends
   # Params:
	#        user_id
   def get_friends
      friends = Friend.where(user_id: params[:user_id])
	  render json:friends
   end

   # Creates a friend request if it does not yet exist
   # Params:
   #         user_id
   #         friend's user_id
   # Returns -1 if unsuccessful, or the id of the friendship
   # if successful.
   def create_request
      friendship = Friend.new(:user_id => params[:user_id], 
							  :friend_id => params[:friend_id])
	  if friendship.save
	    render text: friendship.id 
	  else
	    render text:'-1'
	  end
   end

   # Sets status of friend request to accepted
   # Params: friendship id
   def accept_request

   end

   # Destroys the friend request
   # Params: friendship id
   def decline_request

   end

   # Returns pending friend requests sent but
   # Params: user_id
   def requests_sent

   end

   # Returns pending friend requests received 
   # Params: user_id
   def requests_received

   end

end
