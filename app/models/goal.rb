class Goal < ActiveRecord::Base
  belongs_to :goal_type
  belongs_to :activity
  belongs_to :completing_measurement, class_name: "Measurement", foreign_key: "completing_measurement_id"

  # This ensures that when an out of date goal is accessed, it is marked as inactive and rescheduled.
  # QUESTION: Will the newly created goal need to be fetched separately?
  after_find do |goal|
  	goal.check_for_rescheduling
  end

  def time_due
  	return self.start_time + self.goal_type.days_to_complete.days
  end

  def check_for_completion(measurement)
  	if measurement.measurement_type_id != self.goal_type.measurement_type_id
  		return
  	end

  	if ((measurement.value >= self.goal_type.measure_value and self.goal_type.requires_greater) or (measurement.value <= self.goal_type.measure_value and not self.goal_type.requires_greater))
  		self.completing_measurement = measurement
  		self.active = false
  		self.save
  		if self.goal_type.is_repeated
  			self.schedule_next_iteration
  		end
  	end
  end

  def check_for_rescheduling
  	if Time.now > self.time_due
  		self.active = false
  		self.save
  		if self.goal_type.is_repeated
  			self.schedule_next_iteration
  		end
  	end
  end

  scope :recent, -> { order('created_at desc').limit(4) }

  private
  	def schedule_next_iteration
  		new_goal = Goal.new
  		new_goal.goal_type_id = self.goal_type_id
  		new_goal.activity_id = self.activity_id
  		new_goal.completing_measurement = nil
  		new_goal.start_time = self.time_due
  		new_goal.active = true
  		new_goal.save
  		new_goal.check_for_rescheduling
  	end
end
