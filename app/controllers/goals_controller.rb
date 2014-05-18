class GoalsController < ApplicationController
    def index
        viewed_user = User.find_by_username(params[:username])
		if (params[:username] == nil || is_current_user(viewed_user.username))
		    # Render user's personal goals page
			render 'my_goals'
		elsif (are_friends(current_user.id, viewed_user.id))
			# Show friend-permissable view
		    render 'friend_goals'
		else
			# Render non-friend page
			render 'non_friend_goals'
		end
	end
end
