# TODO: update and delete look copy-pasted.

class ActivitiesController < ApplicationController
    def create_activity
        # Parse json
        json = JSON.parse(params[:json])

        # Create return hash
        to_return = {}

        # Create activity
    	activity = Activity.new
    	activity.user = current_user

        # Normalize activity name
        activity_name = json[:activity_name].split.map(&:capitalize).join(' ')

        # Find activity type.
        activity_type = ActivityType.find_by(name: activity_name)
        if activity_type.nil?
            activity_type = ActivityType.new
            activity_type.name = activity_name
            activity_type.num_users = 0
            if not activity_type.save
                # Activity_type save error
                to_return["hapapp_error"] = "Could not save the activity type."
                to_return["errors"] = activity_type.errors.full_messages
                render json: to_return
                return
            end
        end

        # Save the activity.
    	activity.activity_type = activity_type
    	if activity.save
            activity.activity_type.num_users = activity.activity_type.num_users + 1 # TODO: Could this cause race conditions?
    		# Now, apply the measurement types.
            for measurement_name in json[:measurements] do
                measurement_name = measurement_name.split.map(&:capitalize).join(' ')
                measurement = MeasurementType.find_by(name: measurement_name)
                if measurement.nil?
                    measurement = MeasurementType.new
                    measurement.name = measurement_name
                    measurement.is_quantifiable = true # TODO: Add the ability to make boolean measurement types.
                    if not measurement.save
                        # Measurement save error.
                        to_return["hapapp_error"] = "Could not save new measurement type " + measurement_name + "."
                        if to_return["errors"].nil?
                            to_return["errors"] = []
                        end
                        to_return["errors"].concat(measurement.errors.full_messages)
                        next
                    end
                end
                activity.measurement_types << measurement
            end
    	else
    		# Activity couldn't save
            to_return["hapapp_error"] = "Could not save activity."
            to_return["errors"] = activity.errors.full_messages
            render json: to_return
            return
    	end

        # TODO: Build the json to return.
        render json: to_return
    end

    # TODO: Allow for measurement notes to be submitted.
    def track_new_measurement
        # Parse json
        json = JSON.parse(params[:json])

        # Hash to return
        to_return = {}

        # Check to ensure that such an activity type exists.
        activity_name = json[:activity_name].split.map(&:capitalize).join(' ')
        activity_type = ActivityType.find_by(name: activity_name)
        if activity_type.nil?
            to_return["hapapp_error"] = "There is no activity type with that name."
            render json: to_return
            return
        end

        # Check to ensure that the user is associated with that activity.
        activity = Activity.where("activity_type_id = ? AND user_id = ?", activity_type.id, current_user.id)
        if activity.nil?
            to_return["hapapp_error"] = "The current user is not associated with that activity type."
            render json: to_return
            return
        end

        for measurement_name in json[:measurements] do
            measurement_name = measurement_name.split.map(&:capitalize).join(' ')
            measurement_type = MeasurementType.find_by(name: measurement_name)
            if measurement_type.nil?
                to_return["hapapp_error"] = "The measurement " + measurement_name + " doesn't exist."
                next
            end
            measurement = Measurement.new
            measurement.measurement_type = measurement_type
            measurement.activity = activity
            measurement.value = json[:measurements][measurement_name]
            if not measurement.save
                to_return["hapapp_error"] = "Could not save all measurements."
                if to_return["errors"].nil?
                    to_return["errors"] = []
                end
                to_return["errors"].concat(measurement.errors.full_messages)
            end
        end

        # TODO: Do we need more to return in the json?
        render json: to_return
    end

    # TODO: Handle end behavior.
    # TODO: Change to be part of the create_activity endpoint.
    #def create_activity_type
    # 	@act_type = ActivityType.new
    #	name = params[:name].split.map(&:capitalize).join(' ')
    #	@act_type.name = name
    #
    #	if @act_type.save
    #		# Render something.
    #	else
    #		# Report error.
    #	end
    #end

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
