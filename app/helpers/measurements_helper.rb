module MeasurementsHelper

  def recent_measurements(user_id)
    measurement_blobs = Measurement.where(user_id:user_id).recent 
  end

  def get_recent_measurement_hashes(user_id)
    measurement_blobs = Measurement.where(user_id:user_id).recent 
    return generate_measurement_hashes(measurement_blobs)   	
  end

  def generate_measurement_hashes(measurement_blobs)
    results = []
    measurement_blobs.each do |measurement|
      activity = Activity.find(measurement.activity_id)
	  measurement_type = MeasurementType.find(measurement.measurement_type_id)
	  measurement_note = MeasurementNote.find(measurement.measurement_note_id)
	  activity_type = ActivityType.find(activity.activity_type_id)
      results = {:activity => activity,
		         :activity_type => activity_type,
				 :measurement => measurement,
				 :measurement_type => measurement_type,
				 :measurement_note => measurement_note,
				 :type => 'measurement',
				 :timestamp => measurement.created_at
	  }
	  results << result
	end	
  end

end
