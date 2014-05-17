module MeasurementsHelper

  def recent_measurements(user_id)
    measurement_blobs = Measurement.where(user_id:user_id).recent      
  end

end
