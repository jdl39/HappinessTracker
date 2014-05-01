# TODO: update and delete look copy-pasted.

class ActivitiesController < ApplicationController
    # TODO: Handle correct end behavior. (JSON)
    # TODO: Allow for measurement type to be given?
    def create_activity
    	@activity = Activity.new
    	@activity.user = current_user
    	@activity.activity_type = ActivityType.find_by(name: params[:activity_type_name])
        # TODO: Couple measurements. Create if doesn't exist.
    	if @activity.save
    		if @activity.activity_type.update_attribute(:num_users, @activity.activity_type.num_users + 1) # TODO: Could this cause race conditions?
    			# Redirect somewhere swanky
    		else
    			# Report error?
    		end
    	else
    		# Report error?
    	end
    end

    # TODO: Handle end behavior.
    # TODO: Change to be part of the create_activity endpoint.
    def create_activity_type
    	@act_type = ActivityType.new
    	name = params[:name].split.map(&:capitalize).join(' ')
    	@act_type.name = name
    	@act_type.num_users = 0
    	if @act_type.save
    		# Render something.
    	else
    		# Report error.
    	end
    end

    # Intelligent search for activities
    # Must include:
    # BOOLEAN: stringIsExistingActivity (do we need to present the "add new" option)
    # BOOLEAN: userHasDone
    # OBJECT: mostProbable activity
    # => Should have all data needed to render (past measurements, measurement-types, etc.)
    # => Should also include friends who do activity
    # LIST OF STRINGS: otherProbableActivities
    def search
    	# TODO: Implement.
    end

    # Takes in an activity_type id and a user id and returns all data associated with them.
    # TODO: Consider how privacy concerns may affect how this should be handled.
    def data_for_user
    	# Return data_for_user_helper
    end


	private
       # Use callbacks to share common setup or constraints between actions.	   
       def set_activity
		   @activity = Activity.find(params[:id])
	   end

	   # Helper for search and data_for_user
		def data_for_user_helper(user_id, activity_type_id)
			# TODO: Implement.
		end
end
