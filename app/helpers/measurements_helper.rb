module MeasurementsHelper

  def recent_measurements(user_id)
    measurement_blobs = Measurement.where(user_id:user_id).recent 
  end

  def get_recent_measurement_hashes(user_id)
    activities = Activity.where(user_id:user_id)
    measurement_blobs = []
	activities.each do |activity|
	  measurement_blobs += Measurement.where(activity_id:activity.id)
    end	
    return generate_measurement_hashes(measurement_blobs)   	
  end

  def generate_measurement_hashes(measurement_blobs)
    results = []
    measurement_blobs.each do |measurement|
      activity = Activity.find(measurement.activity_id)
	  user = User.find(activity.user_id)
	  measurement_type = MeasurementType.find(measurement.measurement_type_id)
	  activity_type = ActivityType.find(activity.activity_type_id)
      result = {:activity => activity,
		         :activity_type => activity_type,
				 :measurement => measurement,
				 :measurement_type => measurement_type,
				 :user => user,
				 :type => 'measurement',
				 :timestamp => measurement.created_at
	  }
	  results << result
	end
    return results	
  end

end
