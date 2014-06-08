class FriendsController < ApplicationController
   include FriendsHelper

   def index
      viewed_user = User.find_by_username(params[:username])
	  if (params[:username] == nil || is_current_user(viewed_user.username))
	     # Render user's personal friends page     
	     @accepted_friends = get_friend_info(current_user.id, true)
		 @unaccepted_friends = get_friend_info(current_user.id, false)
		 render 'my_friends'
	  elsif (are_friends(current_user.id, viewed_user.id))
	     # Show friend-view of friends page
		 @accepted_friends = get_friend_info(current_user.id, true)
	     @unaccepted_friends = get_friend_info(viewed_user.id, false)
		 render 'friend_friends'
	  else
	     #Render non-friend friends' page
	     render 'non_friend_friends'
	  end
   end

   # Retrieves a user's accepted friends
   # Params:
   #        username
   def get_friends
     results = []
     user = User.find_by_username(params[:username])
      friends = Friend.where(user_id: user.id, accepted: true)
     friends.each do |friend_rel|
       friend = User.find(friend_rel.friend_id)
      results << {id:friend.id, username: friend.username}
     end
     friends = Friend.where(friend_id: user.id, accepted: true)
     friends.each do |friend_rel|
        friend = User.find(friend_rel.user_id)
       results << {id:friend.id, username: friend.username}
     end
     render json:results
   end

   # Retrieves a current user's accepted friends and returns fullname additionally
   def get_my_friends
     remember_token = User.digest(cookies[:remember_token])
     current_user ||= User.find_by(remember_token: remember_token)
     p "current_user", current_user
     results = []
     # user = User.find_by_username(current_user.id)
     friends = Friend.where(user_id: current_user.id, accepted: true)
     friends.each do |friend_rel|
        friend = User.find(friend_rel.friend_id)
        results << {id: friend.id, username: friend.username, fullname: friend.first_name.capitalize + ' ' + friend.last_name.capitalize}
     end
     friends = Friend.where(friend_id: current_user.id, accepted: true)
     friends.each do |friend_rel|
        friend = User.find(friend_rel.user_id)
        results << {id: friend.id, username: friend.username, fullname: friend.first_name.capitalize + ' ' + friend.last_name.capitalize}
     end
     render json:results
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
