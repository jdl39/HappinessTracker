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

  #Populate friend information
  def recent_friendships(user_id)
    friendships = Friend.where(user_id:user_id, accepted:true).recent
	friendships += Friend.where(friend_id:user_id, accepted:true).recent
	return populate_friend_hashes(friendships)
  end

  # Populates friend hashes
  def populate_friend_hashes(friendships)
    results = []
	friendships.each do |friendship|
      user_1 = User.find(friendship.user_id) 
	  user_2 = User.find(friendship.friend_id)
	  result = {:user_1 => user_1,
	          :user_2 => user_2,	
			  :type => 'friendship',
			  :timestamp => friendship.updated_at
	  }   
	  results << result
    end 
  return results
  end


end
