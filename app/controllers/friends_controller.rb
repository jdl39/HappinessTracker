class FriendsController < ApplicationController
   def index
      # Will need to have three different templates to route to based on if same user, friends, non_friends
   end

   # Retrieves a user's accepted friends
   # Params:
	#        user_id
   def get_friends
      friends = Friend.where(user_id: params[:user_id], accepted: true)
	  friends << Friend.where(friend_id: params[:user_id], accepted: true)
	  render json:friends
   end

   # Creates a friend request if it does not yet exist
   # Params:
   #         user_id
   #         friend's user_id
   # Returns -1 if unsuccessful, or the id of the friendship
   # if successful.
   # TODO: Add validation that user id is that of current user
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
   # TODO: Check that the request has the same user id as current
   # user
   def accept_request
      friendship = Friend.find(params[:request_id])
	  if friendship
		  friendship.accepted = true
		  friendship.save
		  render text: friendship.id
	  else
		  render text: '-1'
      end
   end

   # Destroys the friend request
   # Params: friendship id
   # Returns id of declined friend
   # TODO: Check that the request has the same user id as current
   # user
   def decline_request
       friendship = Friend.find(params[:request_id])
       if friendship
		  friend_id = friendship.friend_id
	      friendship.destroy
		  render text: friend_id
	   else
	      render text: '-1' 
	   end  
   end

   # Returns pending friend requests sent but
   # Params: user_id
   # TODO: Check that the request has the same user id as current
   # user
   def requests_sent
       friends = Friend.where(user_id: params[:user_id], accepted: false)
	   render json:friends
   end

   # Returns pending friend requests received 
   # Params: user_id
   # TODO: Check that the request has the same user id as current user
   def requests_received
       friends = Friend.where(friend_id: params[:user_id], accepted: false)
	   render json:friends
   end

end
