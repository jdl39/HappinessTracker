class GoalsController < ApplicationController
	before_action :setup_goals

    def index
    	if params[:username].nil?
    		@user = current_user
    		puts "HI"
    	else
    		@user = User.find_by_username(params[:username])
    	end
        #viewed_user = User.find_by_username(params[:username])
		#if (params[:username] == nil || is_current_user(viewed_user.username))
		#    # Render user's personal goals page
		#	render 'my_goals'
		#elsif (are_friends(current_user.id, viewed_user.id))
		#	# Show friend-permissable view
		#    render 'friend_goals'
		#else
		#	# Render non-friend page
		#	render 'non_friend_goals'
		#end

		active_goals = []
		completed_goals = []
		@user.activities.each do |activity|
			active_goals.concat Goal.where('activity_id = ? AND active = ?', activity.id, true)
			completed_goals.concat Goal.where('activity_id = ? AND active = ? AND completing_measurement_id IS NOT NULL', activity.id, false)
		end

		@active_goal_hashs = []
		active_goals.each do |g|
			g_hash = {}
			g_hash[:activity_name] = g.goal_type.activity_type.name
			g_hash[:measurement_name] = g.goal_type.measurement_type.name
			g_hash[:measurement_value] = g.goal_type.measurement_value
			g_hash[:due] = g.start_time + g.goal_type.days_to_complete.days
			@active_goal_hashs << g_hash
		end

		@completed_goal_hashs = []
		completed_goals.each do |g|
			g_hash = {}
			g_hash[:activity_name] = g.goal_type.activity_type.name
			g_hash[:measurement_name] = g.goal_type.measurement_type.name
			g_hash[:measurement_value] = g.goal_type.measurement_value
			g_hash[:due] = g.start_time + g.goal_type.days_to_complete.days
			g_hash[:completed_on] = g.completing_measurement.created_at
			@completed_goal_hashs << g_hash
		end

		render 'goals'
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

	private

	def setup_goals
    	Goal.setup_goals_for(current_user)
    end
end
