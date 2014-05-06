class FriendsController < ApplicationController

   # Retrieves a user's accepted friends
   # Params:
	#        user_id
   def get_friends:

   end

   # Creates a friend request if it does not yet exist
   # Params:
   #         user_id
   #         friend's user_id
   def create_request:

   end

   # Sets status of friend request to accepted
   # Params: friendship id
   def accept_request:

   end

   # Destroys the friend request
   # Params: friendship id
   def decline_request:

   end

   # Returns pending friend requests sent but
   # Params: user_id
   def requests_sent:

   end

   # Returns pending friend requests received 
   # Params: user_id
   def requests_received:

   end

end
