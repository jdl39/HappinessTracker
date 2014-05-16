module FriendsHelper

	def get_friend_info(user_id)
        friends = []
		friend_relationships = Friend.where(user_id: user_id, accepted: true)
	    friend_relationships.each do |friend_relationship|
            friends << User.find(friend_relationship.friend_id)
		end
		friend_relationships = Friend.where(friend_id: user_id, accepted: true)
	    friend_relationships.each do |friend_relationship|
		    friends << User.find(friend_relationship.user_id)
        end
	    return friends	
	end 

end
