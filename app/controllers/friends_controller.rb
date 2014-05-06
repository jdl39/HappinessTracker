class FriendsController < ApplicationController

   # Retrieves a user's accepted friends
   # Params:
	#        user_id
   def get_friends:

   end

   # Creates a friendship
   # Params:
   #         user_id
   #         friend's user_id
   def create_friend_request:

   end

   # Sets status to accepted
   # Params: friendship id
   def accept_friend_request:

   end

   # Destroys the friend request
   # Params: friendship id
   def decline_friend_request:

   end

   # Returns friend requests sent but
   # not yet accepted
   # Params: user_id
   def get_friend_requests_sent:

   end

   # Returns friend requests received but
   # not yet accepted
   # Params: user_id
   def get_friend_requests_received:

   end

end
