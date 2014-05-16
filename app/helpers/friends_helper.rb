module FriendsHelper

	def get_friend_info (user_id, accepted)
        friends = []
		if accepted
		    friend_relationships = Friend.where(user_id: user_id, accepted: accepted)
	        friend_relationships.each do |friend_relationship|
                friend_found = User.find(friend_relationship.friend_id)
			    friend_found.request_id = friend_relationship.id
			    friends << friend_found
		    end
		end
		friend_relationships = Friend.where(friend_id: user_id, accepted: accepted)
	    friend_relationships.each do |friend_relationship|
		    friend_found = User.find(friend_relationship.user_id)
			friend_found.request_id = friend_relationship.id
			friends << friend_found
        end
	    return friends	
	end 
end
