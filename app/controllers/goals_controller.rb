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

	def new_goal
		activity_type = ActivityType.find_by(name: params[:goal][:activity_name].downcase)
		measurement_type = MeasurementType.find_by(name: params[:goal][:measurement_type].downcase)
		measurement_value = params[:goal][:measurement_value].to_f
		days_to_complete = params[:goal][:days_to_complete].to_i
		is_repeated = params[:goal][:is_repeated]
		requires_greater = params[:goal][:requires_greater]

		new_goal = Goal.new
		new_goal.goal_type = GoalType.goal_type_for(activity_type, measurement_type, is_repeated, requires_greater, measurement_value, days_to_complete)
		new_goal.activity = Activity.find_by(activity_type: activity_type, user: current_user)
		new_goal.start_time = Time.now
		new_goal.active = true
		new_goal.save
		render inline: "done"
	end
end
